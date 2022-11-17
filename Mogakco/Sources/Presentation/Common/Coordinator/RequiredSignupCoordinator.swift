//
//  RequiredSignupCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class RequiredSignupCoordinator: Coordinator, RequiredSignupCoordinatorProtocol {
    
    weak var delegate: AuthCoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var email: String?
    var password: String?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showEmail()
    }
    
    func showEmail() {
        let emailViewModel = SetEmailViewModel(coordinator: self)
        let emailViewController = SetEmailViewController(viewModel: emailViewModel)
        navigationController.pushViewController(emailViewController, animated: true)
    }
    
    func showPassword() {
        let passwordViewModel = SetPasswordViewModel(coordinator: self)
        let passwordViewController = SetPasswordViewController(viewModel: passwordViewModel)
        navigationController.pushViewController(passwordViewController, animated: true)
    }
    
    func finish() {
        delegate?.requiredSignupCoordinatorDidFinish(child: self, email: email, password: password)
    }
}
