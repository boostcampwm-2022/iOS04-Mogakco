//
//  SignupUseCaseProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct SignupUseCase: SignupUseCaseProtocol {
    
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
    
    func signup(user: User) -> Observable<Void> {
        return authRepository.signup(user: user)
            .flatMap { userRepository.save(user: $0) }
    }
}
