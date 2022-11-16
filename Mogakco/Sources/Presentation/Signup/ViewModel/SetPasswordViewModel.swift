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
        let passwordStorage = BehaviorSubject<String>(value: "")
        let passwordCheckStorage = BehaviorSubject<String>(value: "")
        let passwordState = PublishSubject<Bool>()
        let passwordCheckState = PublishSubject<Bool>()
        let nextButtonEnabled = Observable
            .combineLatest(passwordState, passwordCheckState)
            .map { $0.0 == true && $0.1 == true }
        
        input.password
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                let result = self?.validate(password: text) ?? false
                passwordStorage.onNext(text)
                passwordState.onNext(result)
            })
            .disposed(by: disposeBag)
        
        input.passwordCheck
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                let result = text == (try? passwordStorage.value())
                passwordCheckStorage.onNext(text)
                passwordCheckState.onNext(result)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .subscribe { _ in
                if let password = try? passwordStorage.value() {
                    // TODO: 코디네이터 필요
                    print("그 다음 화면으로", password)
                }
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
