//
//  AppCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

final class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.backgroundColor = .mogakcoColor.backgroundDefault
        window?.makeKeyAndVisible()
    }
    
    func start() {
        showAuthFlow()
//        showMainFlow()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.delegate = self
        authCoordinator.start()
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController)
        childCoordinators.append(tabCoordinator)
        tabCoordinator.delegate = self
        tabCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {

    func coordinatorDidFinish(child: Coordinator) {
        finish(child)
        switch child {
        case is AuthCoordinator:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        case is TabCoordinator:
            navigationController.viewControllers.removeAll()
            showAuthFlow()
        default:
            break
        }
    }
}
