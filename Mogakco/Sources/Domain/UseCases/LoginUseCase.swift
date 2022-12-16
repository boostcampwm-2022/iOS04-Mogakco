//
//  LoginUseCase.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct LoginUseCase: LoginUseCaseProtocol {
    
    var authRepository: AuthRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func login(emailLogin: EmailLogin) -> Observable<Void> {
        return (authRepository?.login(emailLogin: emailLogin) ?? .empty())
            .flatMap { tokenRepository?.save($0) ?? .empty() }
            .map { _ in () }
    }
}
