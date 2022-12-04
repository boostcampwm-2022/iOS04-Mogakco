//
//  LaunchCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum LaunchCoordinatorResult {
    case finish(Bool)
}

final class LaunchCoordinator: BaseCoordinator<LaunchCoordinatorResult> {
    
    override func start() -> Observable<LaunchCoordinatorResult> {
        guard let viewModel = DIContainer.shared.container.resolve(LaunchScreenViewModel.self) else {
            return .empty()
        }
        
        let finish = PublishSubject<Bool>()
        viewModel.finishObserver = finish.asObserver()

        let viewController = LaunchScreenViewController(viewModel: viewModel)
        push(viewController, animated: true)
        
        return finish
            .map { LaunchCoordinatorResult.finish($0) }
//            .do(onNext: { [weak self] _ in self?.pop(animated: true) })
    }
}
