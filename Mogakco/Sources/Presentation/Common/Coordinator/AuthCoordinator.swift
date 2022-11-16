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
        showSignup()
    }
    
    func showLogin() {
        let loginViewController = LoginViewController()
        navigationController.viewControllers = [loginViewController]
    }
    
    func showSignup() {
        let signupCoordinator = SignupCoordinator(navigationController)
        childCoordinators.append(signupCoordinator)
        signupCoordinator.delegate = self
        signupCoordinator.start()
    }
    
    func showSocialSignup(email: String? = nil, password: String? = nil) {
        let socialSignupCoordinator = SocialSignupCoordinator(navigationController)
        childCoordinators.append(socialSignupCoordinator)
        socialSignupCoordinator.delegate = self
        socialSignupCoordinator.start()
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
    
    func signupCoordinatorDidFinish(child: Coordinator, email: String?, password: String?) {
        finish(child)
        showSocialSignup(email: email, password: password)
    }
    
    func socialSignupCoordinatorDidFinish(child: Coordinator, success: Bool) {
        finish(child)
        if success {
            delegate?.coordinatorDidFinish(child: self)
        } else {
            showLogin()
        }
    }
}
