//
//  PolicyViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

enum PolicyNavigation {
    case next
    case back
}

final class PolicyViewModel: ViewModel {
    
    struct Input {
        let totalPolicy: ControlProperty<Bool>
        let servicePolicy: ControlProperty<Bool>
        let contentPolicy: ControlProperty<Bool>
        let nextButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let nextButtonEnabled: Signal<Bool>
    }
    
    let navigation = PublishSubject<PolicyNavigation>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nextButtonEnabled = PublishSubject<Bool>()
        
        input.totalPolicy
            .subscribe(onNext: {
                nextButtonEnabled.onNext($0)
                input.servicePolicy.onNext($0)
                input.contentPolicy.onNext($0)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.servicePolicy, input.contentPolicy)
            .map { $0 == true && $1 == true }
            .bind(to: nextButtonEnabled)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .map { .next }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(nextButtonEnabled: nextButtonEnabled.asSignal(onErrorJustReturn: false))
    }
}
