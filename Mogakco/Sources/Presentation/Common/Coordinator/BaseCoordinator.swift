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
    
    private let identifier = String(describing: ResultType.self)
    
    private var childCoordinators: [String: Any] = [:] {
        didSet {
            print("@@ Child Coordinators 변경됨 @@ ") // TODO: 삭제
            print(childCoordinators)
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n\n")
        }
    }
    
    let navigationController: UINavigationController
    
    let back = PublishSubject<Void>()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented!!")
    }
    
    // MARK: - Child Coordinator
    
    private func append<T>(coordinator: BaseCoordinator<T>) {
        print("🟢", #function, String(describing: coordinator), terminator: "\n\n") // TODO: 삭제
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func remove<T>(coordinator: BaseCoordinator<T>) {
        print("🔴", #function, String(describing: coordinator), terminator: "\n\n") // TODO: 삭제
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinator<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        print(#function, String(describing: coordinator), terminator: "\n\n") // TODO: 삭제
        append(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.remove(coordinator: coordinator) })
    }
    
    // MARK: - Push ∙ Pop
    
    func push(_ viewController: UIViewController, animated: Bool) {
        print(#function, String(describing: viewController), terminator: "\n\n") // TODO: 삭제
        navigationController.pushViewController(viewController, animated: animated)
        print(navigationController.viewControllers, terminator: "\n\n") // TODO: 삭제
    }
    
    func pushTabbar(_ viewController: UIViewController, animated: Bool) {
        print(#function, String(describing: viewController), terminator: "\n\n") // TODO: 삭제
        navigationController.tabBarController?.navigationController?.pushViewController(
            viewController,
            animated: animated
        )
        print(navigationController.tabBarController?.navigationController?.viewControllers, terminator: "\n\n") // TODO: 삭제
    }
    
    func pop(animated: Bool) {
        print(#function, terminator: "\n\n")
        if navigationController.viewControllers.count == 1 {
            navigationController.viewControllers = []
        } else {
            navigationController.popViewController(animated: animated)
        }
        print(navigationController.viewControllers, terminator: "\n\n") // TODO: 삭제
    }
    
    func popAll() {
        print(#function, terminator: "\n\n")
        navigationController.viewControllers = []
        print(navigationController.tabBarController?.navigationController?.viewControllers, terminator: "\n\n") // TODO: 삭제
    }
    
    func popTabbar(animated: Bool) {
        print(#function, terminator: "\n\n")
        navigationController.tabBarController?.navigationController?.popViewController(animated: animated)
        print(navigationController.tabBarController?.navigationController?.viewControllers, terminator: "\n\n") // TODO: 삭제
    }
    
    // MARK: - Present ∙ Dismiss
    
    func presentTabbar(_ viewController: UIViewController, animated: Bool) {
        print(#function, String(describing: viewController), terminator: "\n\n") // TODO: 삭제
        navigationController.tabBarController?.present(viewController, animated: animated)
    }
    
    func dismissTabbar(animated: Bool) {
        print(#function, terminator: "\n\n") // TODO: 삭제
        navigationController.tabBarController?.dismiss(animated: animated)
    }
}
