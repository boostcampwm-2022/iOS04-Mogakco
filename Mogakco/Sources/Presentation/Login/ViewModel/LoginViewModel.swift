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
        let viewWillAppear: Observable<Void>
        let email: Observable<String>
        let password: Observable<String>
        let signupButtonTap: Observable<Void>
        let loginButtonTap: Observable<Void>
    }
    
    struct Output {
        let presentLogin: Signal<Void>
        let presentError: Signal<String>
    }
    
    var autoLoginUseCase: AutoLoginUseCaseProtocol?
    var loginUseCase: LoginUseCaseProtocol?
    let navigation = PublishSubject<LoginNavigation>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {

        let presentLogin = PublishSubject<Void>()
        let presentAlert = PublishSubject<Error>()
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { $0.0.autoLoginUseCase?.load() ?? .empty() }
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                if result {
                    viewModel.navigation.onNext(.finish)
                } else {
                    presentLogin.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        input.signupButtonTap
            .map { LoginNavigation.signup }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.loginButtonTap
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .map { EmailLogin(email: $0, password: $1) }
            .withUnretained(self)
            .flatMap { $0.0.loginUseCase?.login(emailLogin: $0.1).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.navigation.onNext(.finish)
                case .failure(let error):
                    presentAlert.onNext(error)
                }
            })
            .disposed(by: disposeBag)
            
        return Output(
            presentLogin: presentLogin.asSignal(onErrorSignalWith: .empty()),
            presentError: presentAlert.map { $0.localizedDescription }.asSignal(onErrorSignalWith: .empty())
        )
    }
}
