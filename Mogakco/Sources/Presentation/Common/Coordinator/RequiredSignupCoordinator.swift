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
        // TODO: 뷰 컨트롤러에서 코디네이터로 이메일 데이터 넘겨줘야 함
        let emailViewController = SetEmailViewController()
        navigationController.pushViewController(emailViewController, animated: true)
    }
    
    func showPassword() {
        // TODO: 뷰 컨트롤러에서 코디네이터로 패스워드 데이터 넘겨줘야 함
        let passwordViewController = SetPasswordViewController()
        navigationController.pushViewController(passwordViewController, animated: true)
    }
    
    func finish() {
        delegate?.requiredSignupCoordinatorDidFinish(child: self, email: email, password: password)
    }
}
