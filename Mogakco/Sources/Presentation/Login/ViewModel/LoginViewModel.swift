//
//  LoginViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModel {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let signupButtonTap: Observable<Void>
        let loginButtonTap: Observable<Void>
    }
    
    struct Output {}
    
    var disposeBag = DisposeBag()
    private let loginUseCase: LoginUseCaseProtocol
    private let coordinator: AuthCoordinatorProtocol
    
    
    init(coordinator: AuthCoordinatorProtocol, loginUseCase: LoginUseCaseProtocol) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    func transform(input: Input) -> Output {
        enum LoginError: Error, LocalizedError {
            case loginFail
        }
        
        var userData = EmailLogin(email: "", password: "")
        
        Observable
            .combineLatest(input.email, input.password)
            .subscribe { email, password in
                userData = EmailLogin(email: email, password: password)
            }
            .disposed(by: disposeBag)
        
        input.signupButtonTap
            .subscribe(onNext: { [weak self] in
                self?.coordinator.showRequiredSignup()
            })
            .disposed(by: disposeBag)
        
        input.loginButtonTap
            .flatMap { [weak self] () -> Observable<Void> in
                guard let self else { return  Observable.error(LoginError.loginFail) }
                return self.loginUseCase.login(emailLogin: userData)
            }
            .subscribe(onNext: { [weak self] in
                self?.coordinator.finish()
            })
            .disposed(by: disposeBag)
            
        return Output()
    }
}
