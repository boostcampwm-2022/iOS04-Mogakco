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
    
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.tokenRepository = tokenRepository
    }
    
    func login(emailLogin: EmailLogin) -> Observable<Void> {
        return authRepository.login(emailLogin: emailLogin)
            .flatMap { tokenRepository.save($0) }
            .compactMap { $0 }
            .map { $0.localId }
            .flatMap { userRepository.user(id: $0) }
            .flatMap { userRepository.save(user: $0) }
    }
}
