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
        return authRepository?.login(emailLogin: emailLogin)
            .flatMap { tokenRepository?.save($0) ?? .empty() }
            .compactMap { $0 }
            .map { $0.localId }
            .flatMap { userRepository?.user(id: $0) ?? .empty() }
            .flatMap { userRepository?.save(user: $0) ?? .empty() } ?? .empty()
    }
}
