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
    
    private let autoLoginUseCase: AutoLoginUseCaseProtocol
    private let finishObserver: AnyObserver<Bool>?
    var disposeBag = DisposeBag()
    
    init(
        autoLoginUseCase: AutoLoginUseCaseProtocol,
        finishObserver: AnyObserver<Bool>? = nil
    ) {
        self.autoLoginUseCase = autoLoginUseCase
        self.finishObserver = finishObserver
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { $0.0.autoLoginUseCase.load() }
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { viewModel, result in
                viewModel.finishObserver?.onNext(result)
            }
            .disposed(by: disposeBag)
        return Output()
    }
}
