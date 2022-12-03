//
//  LoginCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum LoginCoordinatorResult {
    case finish
}

final class MLoginCoordinator: BaseCoordinator<LoginCoordinatorResult> {
    
    let finish = PublishSubject<LoginCoordinatorResult>()
    
    override func start() -> Observable<LoginCoordinatorResult> {
        showLogin()
        return finish
            .do(onNext: { [weak self] _ in self?.pop(animated: false) })
    }
    
    // MARK: - 로그인
    
    func showLogin() {
        let viewModel = LoginViewModel(
            loginUseCase: LoginUseCase(
                authRepository: AuthRepository(
                    authService: FBAuthService(provider: Provider.default)
                ),
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                ),
                tokenRepository: TokenRepository(
                    keychainManager: KeychainManager(keychain: Keychain())
                )
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .signup:
                    self?.showEmail()
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = LoginViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 회원가입 (이메일)

    func showEmail() {
        let email = EmailCoordinator(navigationController)
        
        coordinate(to: email)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish(let result):
                    if result { self?.finish.onNext(.finish) }
                case .back:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
