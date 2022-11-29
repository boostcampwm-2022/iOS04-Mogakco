//
//  AuthCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator, AuthCoordinatorProtocol {
    
    weak var delegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAutoLogin()
    }
    
    func showAutoLogin() {
        let viewController = LaunchScreenViewController(
            viewModel: LaunchScreenViewModel(
                coordinator: self,
                autoLoginUseCase: AutoLoginUseCase(
                    userRepository: UserRepository(
                        localUserDataSource: UserDefaultsUserDataSource(),
                        remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                    ),
                    tokenRepository: TokenRepository(
                        keychainManager: KeychainManager(keychain: Keychain()))
                )
            )
        )
        navigationController.viewControllers = [viewController]
    }
    
    func showLogin() {
        let localUserDataSource = UserDefaultsUserDataSource()
        let remoteUserDataSource = RemoteUserDataSource(provider: Provider.default)
        let authService = FBAuthService(provider: Provider.default)
        let authRepository = AuthRepository(authService: authService)
        let userRepository = UserRepository(
            localUserDataSource: localUserDataSource,
            remoteUserDataSource: remoteUserDataSource
        )
        let tokenRepository = TokenRepository(
            keychainManager: KeychainManager(keychain: Keychain())
        )
        let loginUseCase = LoginUseCase(
            authRepository: authRepository,
            userRepository: userRepository,
            tokenRepository: tokenRepository
        )
        let viewModel = LoginViewModel(coordinator: self, loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController.viewControllers = [loginViewController]
    }
    
    func showRequiredSignup() {
        let signupCoordinator = RequiredSignupCoordinator(navigationController)
        childCoordinators.append(signupCoordinator)
        signupCoordinator.delegate = self
        signupCoordinator.start()
    }
    
    func showAdditionalSignup(passwordProps: PasswordProps) {
        let socialSignupCoordinator = AdditionalSignupCoordinator(
            navigationController,
            passwordProps: passwordProps
        )
        childCoordinators.append(socialSignupCoordinator)
        socialSignupCoordinator.delegate = self
        socialSignupCoordinator.start()
    }
    
    func finish() {
        delegate?.coordinatorDidFinish(child: self)
    }
}

extension AuthCoordinator: AuthCoordinatorFinishDelegate {
    
    func autoLoginCoordinatorDidFinish(child: Coordinator, success: Bool) {
        finish(child)
        if success {
            delegate?.coordinatorDidFinish(child: self)
        } else {
            showLogin()
        }
    }
    
    func requiredSignupCoordinatorDidFinish(child: Coordinator, passwordProps: PasswordProps) {
        finish(child)
        showAdditionalSignup(passwordProps: passwordProps)
    }
    
    func additionalSignupCoordinatorDidFinish(child: Coordinator, success: Bool) {
        finish(child)
        if success {
            delegate?.coordinatorDidFinish(child: self)
        } else {
            showLogin()
        }
    }
}
