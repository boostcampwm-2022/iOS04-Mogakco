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
        case create, edit
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
  
        let name = Observable.merge(
            user.compactMap { $0?.name },
            input.name
        )
        
        let introduce = Observable.merge(
            user.compactMap { $0?.introduce },
            input.introduce
        )
        
        let profileImage = Observable.merge(
            Observable.just(MogakcoAsset.swift.image), // TODO: 기본 이미지
            // user.compactMap { $0?.profileImage },
            input.selectedProfileImage
        )
        
        let inputValidation = name.map { (2...10).contains($0.count) }
        
        type
            .filter { $0 == .edit }
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase.profile() }
            .subscribe(onNext: {
                user.onNext($0)
            })
            .disposed(by: disposeBag)
        
        let profileEdit = input
            .completeButtonTapped
            .withLatestFrom(type)
            .filter { $0 == .edit }
        
        profileEdit
            .withLatestFrom(
                Observable.combineLatest(name, introduce, profileImage)
            )
            .flatMap { name, introduce, _ in
                self.editProfileUseCase.editProfile(name: name, introduce: introduce)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.pop(animated: true)
            }, onError: { error in
                print("Edit Error \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        let profileCreate = input
            .completeButtonTapped
            .withLatestFrom(type)
            .filter { $0 == .create }
        
        profileCreate
            .withLatestFrom(Observable.combineLatest(
                input.name,
                input.introduce,
                input.selectedProfileImage
            ))
            .subscribe(onNext: { _ in
                if let coordinator = self.coordinator as? AdditionalSignupCoordinator {
                    coordinator.showLanguage()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            originName: user.compactMap { $0?.name },
            originIntroduce: user.compactMap { $0?.introduce },
            originProfileImage: profileImage.take(1),
            inputValidation: inputValidation.asObservable()
        )
    }
}
