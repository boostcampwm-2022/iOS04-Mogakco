//
//  BaseCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

class BaseCoordinator<ResultType> {
    
    typealias CoordinationResult = ResultType
    
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    
    private var childCoordinators: [UUID: Any] = [:]
    
    let navigationController = UINavigationController()
    
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented!!")
    }
    
    // MARK: - Child Coordinator Related Methods
    
    private func append<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func remove<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinator<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        self.append(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.remove(coordinator: coordinator)
                self?.pop(animated: true) // TODO: 여기서 하는게 맞을까?
            })
    }
    
    // MARK: - Helper methods
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func popTabbar(animated: Bool) {
        navigationController.tabBarController?.navigationController?.popViewController(animated: animated)
    }
}
