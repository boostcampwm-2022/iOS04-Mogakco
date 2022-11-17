//
//  SetEmailViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class SetEmailViewModel: ViewModel {
    
    struct Input {
        let email: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let textFieldState: PublishSubject<Bool>
        let nextButtonEnabled: PublishSubject<Bool>
    }
    
    private weak var coordinator: RequiredSignupCoordinatorProtocol?
    var disposeBag = DisposeBag()
    
    init(coordinator: RequiredSignupCoordinatorProtocol?) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        let textFieldState = PublishSubject<Bool>()
        let nextButtonEnabled = PublishSubject<Bool>()
        
        input.email
            .distinctUntilChanged()
            .subscribe { [weak self] text in
                if let result = self?.validate(email: text) {
                    textFieldState.onNext(result)
                    nextButtonEnabled.onNext(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withLatestFrom(input.email)
            .subscribe { [weak self] email in
                self?.coordinator?.email = email
                self?.coordinator?.showPassword()
            }
            .disposed(by: disposeBag)
        
        return Output(
            textFieldState: textFieldState,
            nextButtonEnabled: nextButtonEnabled
        )
    }
    
    private func validate(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
