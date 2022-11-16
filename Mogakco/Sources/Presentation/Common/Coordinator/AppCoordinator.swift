//
//  AppCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        self.navigationController.view.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func start() {
        showAuthFlow()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.finishDelegate = self
        authCoordinator.start()
    }
    
    func showMainFlow() {
        
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { !($0 === childCoordinator) }
    }
}
