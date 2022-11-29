//
//  LaunchScreenViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class LaunchScreenViewModel: ViewModel {
    
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output { }
    
    private let coordinator: AuthCoordinatorProtocol
    private let autoLoginUseCase: AutoLoginUseCaseProtocol
    var disposeBag = DisposeBag()
    
    init(
        coordinator: AuthCoordinatorProtocol,
        autoLoginUseCase: AutoLoginUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.autoLoginUseCase = autoLoginUseCase
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { $0.0.autoLoginUseCase.load() }
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { viewModel, result in
                if result {
                    viewModel.coordinator.finish()
                } else {
                    viewModel.coordinator.showLogin()
                }
            }
            .disposed(by: disposeBag)
        return Output()
    }
}
