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
    private let disposeBag = DisposeBag()
    
    init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func login(emailLoginUser: EmailLogin) -> Observable<Void> {
        return authRepository.login(emailLoginUser: emailLoginUser)
            .flatMap { userRepository.save(userUID: $0) }
    }
}
