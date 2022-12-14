//
//  EditProfileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum EditProfileNavigation {
    case next(Profile)
    case finish
    case back
}

final class EditProfileViewModel: ViewModel {

    enum EditType {
        case create
        case edit
    }
    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let selectedProfileImage: Observable<UIImage>
        let refreshButtonTapped: Observable<Void>
        let completeButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let originName: Driver<String>
        let originIntroduce: Driver<String>
        let originProfileImage: Driver<UIImage>
        let inputValidation: Driver<Bool>
        let alert: Signal<Alert>
    }
    
    var disposeBag = DisposeBag()
    var profileUseCase: ProfileUseCaseProtocol?
    var editProfileUseCase: EditProfileUseCaseProtocol?
    let navigation = PublishSubject<EditProfileNavigation>()
    let type = BehaviorSubject<EditType>(value: .edit)
    private let user = BehaviorSubject<User?>(value: nil)
    private let name = BehaviorSubject<String>(value: "")
    private let introduce = BehaviorSubject<String>(value: "")
    private let image = BehaviorSubject<UIImage>(value: UIImage())
    private let inputValidation = BehaviorSubject<Bool>(value: false)
    private let alert = PublishSubject<Alert>()
    
    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindImage(input: input)
        bindScene(input: input)

        return Output(
            originName: user.compactMap { $0?.name }.asDriver(onErrorJustReturn: ""),
            originIntroduce: user.compactMap { $0?.introduce }.asDriver(onErrorJustReturn: ""),
            originProfileImage: image.asObservable().asDriver(onErrorDriveWith: .empty()),
            inputValidation: inputValidation.asObservable().asDriver(onErrorJustReturn: false),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    private func bindUser(input: Input) {
        type
            .filter { $0 == .edit }
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase?.profile().asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let user):
                    viewModel.user.onNext(user)
                case .failure:
                    let alert = Alert(title: "프로필 편집 오류", message: "프로필 편집가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.name }, input.name)
            .bind(to: name)
            .disposed(by: disposeBag)
        
        name.map { (2...10).contains($0.count) }
            .bind(to: inputValidation)
            .disposed(by: disposeBag)
          
        Observable.merge(user.compactMap { $0?.introduce }, input.introduce)
            .bind(to: introduce)
            .disposed(by: disposeBag)
    }
    
    private func bindImage(input: Input) {
        Observable
            .merge(
                user
                    .compactMap { $0?.profileImageURLString }
                    .compactMap { URL(string: $0) }
                    .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                    .compactMap { try? Data(contentsOf: $0) }
                    .observe(on: MainScheduler.asyncInstance)
                    .compactMap { UIImage(data: $0) },
                input.selectedProfileImage
            )
            .bind(to: image)
            .disposed(by: disposeBag)
        
        Observable.merge(
            type.filter { $0 == .create }.map { _ in },
            input.refreshButtonTapped
        )
            .compactMap { Image.profiles.randomElement() }
            .bind(to: image)
            .disposed(by: disposeBag)
    }
    
    private func bindScene(input: Input) {
        input
            .completeButtonTapped
            .withLatestFrom(type)
            .filter { $0 == .edit }
            .withLatestFrom( Observable.combineLatest(name, introduce, image) )
            .flatMap { [weak self] name, introduce, image in
                self?.editProfileUseCase?.editProfile(name: name, introduce: introduce, image: image) ?? .empty()
            }
            .map { EditProfileNavigation.finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input
            .completeButtonTapped
            .withLatestFrom(type)
            .filter { $0 == .create }
            .withLatestFrom( Observable.combineLatest(input.name, input.introduce, image) )
            .map { Profile(name: $0, introduce: $1, image: $2) }
            .map { EditProfileNavigation.next($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { EditProfileNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
