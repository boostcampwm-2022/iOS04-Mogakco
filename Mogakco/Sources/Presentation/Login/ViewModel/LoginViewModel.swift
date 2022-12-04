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

enum LoginNavigation {
    case signup
    case finish
}

final class LoginViewModel: ViewModel {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let signupButtonTap: Observable<Void>
        let loginButtonTap: Observable<Void>
    }
    
    struct Output {
        let presentError: Signal<String>
    }
    
    var loginUseCase: LoginUseCaseProtocol?
    let navigation = PublishSubject<LoginNavigation>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        enum LoginError: Error, LocalizedError {
            case loginFail
        }
        let presentAlert = PublishSubject<Error>()
        var userData = EmailLogin(email: "", password: "")
        
        Observable
            .combineLatest(input.email, input.password)
            .subscribe { email, password in
                userData = EmailLogin(email: email, password: password)
            }
            .disposed(by: disposeBag)
        
        input.signupButtonTap
            .map { LoginNavigation.signup }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.loginButtonTap
            .withUnretained(self)
            .flatMap { $0.0.loginUseCase?.login(emailLogin: userData).asResult() ?? .empty() }
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .success:
                    self?.navigation.onNext(.finish)
                case .failure(let error):
                    presentAlert.onNext(error)
                }
            })
            .disposed(by: disposeBag)
            
        return Output(
            presentError: presentAlert.map { $0.localizedDescription }.asSignal(onErrorSignalWith: .empty())
        )
    }
}
