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
    
    var autoLoginUseCase: AutoLoginUseCaseProtocol?
    var finishObserver: AnyObserver<Bool>?
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { $0.0.autoLoginUseCase?.load() ?? .empty() }
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { viewModel, result in
                viewModel.finishObserver?.onNext(result)
            }
            .disposed(by: disposeBag)
        return Output()
    }
}
