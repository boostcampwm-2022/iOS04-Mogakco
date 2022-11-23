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
    
    private weak var coordinator: RequiredSignupCoordinatorProtocol?
    private var emailProps: EmailProps
    var disposeBag = DisposeBag()
    
    init(
        coordinator: RequiredSignupCoordinatorProtocol?,
        emailProps: EmailProps
    ) {
        self.coordinator = coordinator
        self.emailProps = emailProps
    }

    func transform(input: Input) -> Output {
        let passwordState = PublishSubject<Bool>()
        let passwordCheckState = PublishSubject<Bool>()
        let nextButtonEnabled = Observable
            .combineLatest(passwordState, passwordCheckState)
            .map { $0.0 == true && $0.1 == true }
        
        input.password
            .distinctUntilChanged()
            .compactMap { [weak self] in
                self?.validate(password: $0)
            }
            .subscribe(onNext: {
                passwordState.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.passwordCheck
            .distinctUntilChanged()
            .withLatestFrom(Observable.combineLatest(input.password, input.passwordCheck))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { $0.0 == $0.1 }
            .subscribe(onNext: {
                passwordCheckState.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withLatestFrom(input.password)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, password in
                let passwordProps = viewModel.emailProps.toPasswordProps(password: password)
                viewModel.coordinator?.finish(passwordProps: passwordProps)
            })
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
