//
//  TabCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class TabCoordinator: Coordinator {
    
    weak var delegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        setRootViewControllers()
        setChildCoordinators()
        navigationController.viewControllers = [tabBarController]
    }
    
    func setRootViewControllers() {
        let rootViewControllers = TabBarType.allCases.map {
            let navigationController = UINavigationController()
            let tabBarItem = UITabBarItem(
                title: $0.title,
                image: UIImage(systemName: $0.image),
                tag: $0.rawValue
            )
            navigationController.tabBarItem = tabBarItem
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
        tabBarController.setViewControllers(rootViewControllers, animated: true)
    }
    
    func setChildCoordinators() {
        TabBarType.allCases.forEach {
            switch $0 {
            case .study:
                let nav = rootNavigationController(tab: $0)
                let child = StudyTabCoordinator(nav)
                childCoordinators.append(child)
                child.start()
            case .chat:
                let nav = rootNavigationController(tab: $0)
                let child = ChatTabCoordinator(nav)
                childCoordinators.append(child)
                child.start()
            case .profile:
                let nav = rootNavigationController(tab: $0)
                let child = ProfileTabCoordinator(nav)
                childCoordinators.append(child)
                child.start()
            }
        }
    }
    
    func rootNavigationController(tab: TabBarType) -> UINavigationController {
        if let rootViewController = tabBarController.viewControllers?[tab.rawValue],
           let navigationController = rootViewController as? UINavigationController {
            return navigationController
        }
        // TODO: Error
        return UINavigationController()
    }
}

extension TabCoordinator {
    
    enum TabBarType: Int, CaseIterable {
        case study
        case chat
        case profile
        
        var title: String {
            switch self {
            case .study: return "홈"
            case .chat: return "채팅"
            case .profile: return "프로필"
            }
        }
        
        var image: String {
            switch self {
            case .study: return "house.fill"
            case .chat: return "bubble.right.fill"
            case .profile: return "person.crop.circle"
            }
        }
    }
}
