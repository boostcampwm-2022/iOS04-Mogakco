//
//  SetPasswordViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

enum SetPasswordNavigation {
    case next(password: String)
    case back
}

final class SetPasswordViewModel: ViewModel {
    
    struct Input {
        let password: Observable<String>
        let passwordCheck: Observable<String>
        let nextButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let passwordState: PublishSubject<Bool>
        let passwordCheckState: PublishSubject<Bool>
        let nextButtonEnabled: Observable<Bool>
    }
    
    let navigation = PublishSubject<SetPasswordNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let passwordState = PublishSubject<Bool>()
        let passwordCheckState = PublishSubject<Bool>()
        let nextButtonEnabled = Observable
            .combineLatest(passwordState, passwordCheckState)
            .map { $0.0 == true && $0.1 == true }
        
        input.password
            .distinctUntilChanged()
            .withUnretained(self)
            .map { $0.0.validate(password: $0.1) }
            .bind(to: passwordState)
            .disposed(by: disposeBag)
        
        input.passwordCheck
            .distinctUntilChanged()
            .withLatestFrom(Observable.combineLatest(input.password, input.passwordCheck))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .withUnretained(self)
            .filter { $0.0.validate(password: $0.1.0) }
            .map { $0.1.0 == $0.1.1 }
            .bind(to: passwordCheckState)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withLatestFrom(input.password)
            .map { SetPasswordNavigation.next(password: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { SetPasswordNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            passwordState: passwordState,
            passwordCheckState: passwordCheckState,
            nextButtonEnabled: nextButtonEnabled
        )
    }
    
    private func validate(password: String) -> Bool {
        let regex = #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d$@$!%*#?&]{6,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
}
