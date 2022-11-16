//
//  AuthCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginViewController = LoginViewController()
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func showSignup() {
        let emailViewController = SetEmailViewController()
        navigationController.pushViewController(emailViewController, animated: true)
    }
    
    func showSocialSignup() {
        
    }
}

extension AuthCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
