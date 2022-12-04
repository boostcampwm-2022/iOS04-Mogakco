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
        let completeButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let originName: Observable<String>
        let originIntroduce: Observable<String>
        let originProfileImage: Observable<UIImage>
        let inputValidation: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    var type: EditType = .edit
    var profileUseCase: ProfileUseCaseProtocol?
    var editProfileUseCase: EditProfileUseCaseProtocol?
    let navigation = PublishSubject<EditProfileNavigation>()
    
    func transform(input: Input) -> Output {
        let type = BehaviorSubject<EditType>(value: type)
        let user = BehaviorSubject<User?>(value: nil)
        let name = BehaviorSubject<String>(value: "")
        let introduce = BehaviorSubject<String>(value: "")
        let image = BehaviorSubject<UIImage>(value: Image.profileDefault)
        let inputValidation = BehaviorSubject<Bool>(value: false)
        
        type
            .filter { $0 == .edit }
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase?.profile() ?? .empty() }
            .subscribe(onNext: {
                user.onNext($0)
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

        input
            .completeButtonTapped
            .withLatestFrom(type)
            .map { $0 == .edit }
            .filter { $0 }
            .withLatestFrom( Observable.combineLatest(name, introduce, image) )
            .flatMap { name, introduce, image in
                self.editProfileUseCase?.editProfile(name: name, introduce: introduce, image: image) ?? .empty()
            }
            .map { EditProfileNavigation.finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    
        input
            .completeButtonTapped
            .withLatestFrom(type)
            .map { $0 == .edit }
            .filter { !$0 }
            .withLatestFrom( Observable.combineLatest(input.name, input.introduce, image) )
            .map { Profile(name: $0, introduce: $1, image: $2) }
            .map { EditProfileNavigation.next($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { EditProfileNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            originName: user.compactMap { $0?.name },
            originIntroduce: user.compactMap { $0?.introduce },
            originProfileImage: image.asObservable(),
            inputValidation: inputValidation.asObservable()
        )
    }
}
