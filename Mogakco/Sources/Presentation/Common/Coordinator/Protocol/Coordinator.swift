//
//  Coordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func finish(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { !($0 === child) }
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func popTabbar(animated: Bool) {
        navigationController.tabBarController?.navigationController?.popViewController(animated: animated) 
    }
}
