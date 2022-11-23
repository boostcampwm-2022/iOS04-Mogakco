//
//  ProfileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModel {
    
    enum ProfileType: Equatable {
        case current
        case other(User)
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.current, .current), (.other, .other):
                return true
            default:
                return false
            }
        }
    }
    
    struct Input {
        let editProfileButtonTapped: Observable<Void>
    }
    
    struct Output {
        let myProfile: Observable<Bool>
        let profileImageURL: Observable<URL>
        let name: Observable<String>
        let introduce: Observable<String>
        let languages: Observable<[String]>
        let careers: Observable<[String]>
        let categorys: Observable<[String]>
    }

    var disposeBag = DisposeBag()
    private let type: ProfileType
    private weak var coordinator: ProfileTabCoordinator?
    private let userUseCase: UserUseCase
 
    init(
        type: ProfileType,
        coordinator: ProfileTabCoordinator,
        userUseCase: UserUseCase
    ) {
        self.type = type
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        let type = BehaviorSubject<ProfileType>(value: type)
        let myProfile = type
            .map { $0 == .current }
        let user = type
            .withUnretained(self)
            .flatMap { viewModel, type -> Observable<User> in
                switch type {
                case .current:
                    return viewModel.userUseCase.myProfile()
                case let .other(user):
                    return viewModel.userUseCase.user(id: user.id ?? "")
                }
            }
        
        input.editProfileButtonTapped
            .subscribe(onNext: {
                self.coordinator?.showEditProfile()
            })
            .disposed(by: disposeBag)
        
        return Output(
            myProfile: myProfile.asObservable(),
            profileImageURL: user.compactMap { URL(string: $0.profileImageURLString) },
            name: user.map { $0.name }.asObservable(),
            introduce: user.map { $0.introduce }.asObservable(),
            languages: user.map { $0.languages }.asObservable(),
            careers: user.map { $0.careers }.asObservable(),
            categorys: user.map { $0.categorys }.asObservable()
        )
    }
}
