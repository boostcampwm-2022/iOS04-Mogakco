//
//  TabCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum TabCoordinatorResult {
    case finish
}

final class TabCoordinator: BaseCoordinator<TabCoordinatorResult> {
    
    enum Tab: Int, CaseIterable {
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
    
    private var tabBarController = UITabBarController()
    private let finish = PublishSubject<TabCoordinatorResult>()
    
    override func start() -> Observable<TabCoordinatorResult> {
        push(tabBarController, animated: true, isRoot: true)
        setup()
        return finish
    }
    
    private func setup() {
        var rootViewControllers: [UINavigationController] = []
        
        Tab.allCases.forEach {
            let navigationController = navigationController(tab: $0)
            rootViewControllers.append(navigationController)
            
            switch $0 {
            case .study: showStudyList(navigationController)
            case .chat: showChatRoomList(navigationController)
            case .profile: showProfile(navigationController)
            }
        }
        
        tabBarController.setViewControllers(rootViewControllers, animated: false)
    }
    
    private func navigationController(tab: Tab) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.image),
            tag: tab.rawValue
        )
        navigationController.tabBarItem = tabBarItem
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    private func showStudyList(_ root: UINavigationController) {
        let child = StudyListCoordinator(root)
        coordinate(to: child)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showChatRoomList(_ root: UINavigationController) {
        let child = ChatRoomListCoordinator(root)
        coordinate(to: child)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showProfile(_ root: UINavigationController) {
        let child = ProfileCoordinator(type: .current, hideTabbar: false, root)
        coordinate(to: child)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
