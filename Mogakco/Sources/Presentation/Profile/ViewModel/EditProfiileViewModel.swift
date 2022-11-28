//
//  EditProfiileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class EditProfiileViewModel: ViewModel {
    
    enum EditType {
        case create(PasswordProps)
        case edit
        
        static func == (lhs: EditType, rhs: EditType) -> Bool {
            switch (lhs, rhs) {
            case (.create, .create), (.edit, .edit):
                return true
            default:
                return false
            }
        }
    }
    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let selectedProfileImage: Observable<UIImage>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let originName: Observable<String>
        let originIntroduce: Observable<String>
        let originProfileImage: Observable<UIImage>
        let inputValidation: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    private let type: EditType
    private weak var coordinator: Coordinator?
    private let profileUseCase: ProfileUseCase
    private let editProfileUseCase: EditProfileUseCase
    
    init(
        type: EditType,
        coordinator: Coordinator,
        profileUseCase: ProfileUseCase,
        editProfileUseCase: EditProfileUseCase
    ) {
        self.type = type
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
        self.editProfileUseCase = editProfileUseCase
    }
    
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
            .flatMap { $0.0.profileUseCase.profile() }
            .subscribe(onNext: {
                user.onNext($0)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.name }, input.name)
            .bind(to: name)
            .disposed(by: disposeBag)
        
        name
            .map { (2...10).contains($0.count) }
            .bind(to: inputValidation)
            .disposed(by: disposeBag)
          
        Observable.merge(user.compactMap { $0?.introduce }, input.introduce)
            .bind(to: introduce)
            .disposed(by: disposeBag)
        
        Observable.merge(
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
                self.editProfileUseCase.editProfile(name: name, introduce: introduce, image: image)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
    
        input
            .completeButtonTapped
            .withLatestFrom(type)
            .map { $0 == .edit }
            .filter { !$0 }
            .withLatestFrom( Observable.combineLatest(input.name, input.introduce, image) )
            .subscribe(onNext: { [weak self] name, introduce, image in
                self?.pushLanguage(name: name, introduce: introduce, image: image)
            })
            .disposed(by: disposeBag)
        
        return Output(
            originName: user.compactMap { $0?.name },
            originIntroduce: user.compactMap { $0?.introduce },
            originProfileImage: image.asObservable(),
            inputValidation: inputValidation.asObservable()
        )
    }
    
    private func pushLanguage(name: String, introduce: String, image: UIImage) {
        guard let coordinator = self.coordinator as? AdditionalSignupCoordinator,
              case let EditType.create(passwordProps) = self.type else {
            return
        }
        let profileProps = passwordProps.toProfileProps(name: name, introduce: introduce, profileImage: image)
        coordinator.showLanguage(profileProps: profileProps)
    }
}
