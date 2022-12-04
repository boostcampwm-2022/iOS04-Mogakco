//
//  SignupEditProfileCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum SignupEditProfileCoordinatorResult {
    case finish(Bool)
    case back
}

final class SignupEditProfileCoordinator: BaseCoordinator<SignupEditProfileCoordinatorResult> {
    
    let passwordProps: PasswordProps
    let finish = PublishSubject<SignupEditProfileCoordinatorResult>()
    
    init(_ passwordProps: PasswordProps, _ navigationController: UINavigationController) {
        self.passwordProps = passwordProps
        super.init(navigationController)
    }
    
    override func start() -> Observable<SignupEditProfileCoordinatorResult> {
        showProfile()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                case .back: self?.pop(animated: true)
                }
            })
    }
    
    // MARK: - 프로필
    
    func showProfile() {
        guard let viewModel = DIContainer.shared.container.resolve(EditProfileViewModel.self) else { return }
        viewModel.type = .create
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .next(let profile):
                    self?.showSelectLanguage(profile: profile)
                case .back:
                    self?.finish.onNext(.back)
                case .finish:
                    fatalError("do not finish")
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = EditProfileViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 언어 선택
    
    func showSelectLanguage(profile: Profile) {
        let profileProps = passwordProps.toProfileProps(profile: profile)
        let language = SignupLanguageHashtagCoordinator(profileProps, navigationController)
        
        coordinate(to: language)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish(let result):
                    self?.finish.onNext(.finish(result))
                case .back:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
