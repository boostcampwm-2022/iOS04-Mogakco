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

final class SetPasswordViewModel: ViewModel {

    var disposeBag = DisposeBag()
    
    struct Input {
        let password: Observable<String>
        let passwordCheck: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let passwordState: PublishSubject<Bool>
        let passwordCheckState: PublishSubject<Bool>
        let nextButtonEnabled: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let passwordState = PublishSubject<Bool>()
        let passwordCheckState = PublishSubject<Bool>()
        let nextButtonEnabled = Observable
            .combineLatest(passwordState, passwordCheckState)
            .map { $0.0 == true && $0.1 == true }
        
        input.password
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                let result = self?.validate(password: text) ?? false
                passwordState.onNext(result)
            })
            .disposed(by: disposeBag)
        
        input.passwordCheck
            .distinctUntilChanged()
            .withLatestFrom(Observable.combineLatest(input.password, input.passwordCheck))
            .subscribe(onNext: { (password, passwordCheck) in
                guard !password.isEmpty else { return }
                let result = password == passwordCheck
                passwordCheckState.onNext(result)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withLatestFrom(input.password)
            .subscribe { password in
                // TODO: 코디네이터 필요
                print("그 다음 화면으로", password)
            }
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
