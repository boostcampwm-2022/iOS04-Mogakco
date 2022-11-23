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
    
    func showPassword(emailProps: EmailProps) {
        let passwordViewModel = SetPasswordViewModel(coordinator: self, emailProps: emailProps)
        let passwordViewController = SetPasswordViewController(viewModel: passwordViewModel)
        navigationController.pushViewController(passwordViewController, animated: true)
    }
    
    func finish(passwordProps: PasswordProps) {
        delegate?.requiredSignupCoordinatorDidFinish(
            child: self,
            passwordProps: passwordProps
        )
    }
}
