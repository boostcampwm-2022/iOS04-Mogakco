//
//  LoginViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

final class LoginViewModel: ViewModel {
    
    struct Input {
        //
    }
    
    struct Output {
        //
    }
    
    var disposeBag = DisposeBag()
    var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func transform(input: Input) -> Output {
            
        return Output()
    }
}
