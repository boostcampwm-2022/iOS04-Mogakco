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
            .do(onNext: {_ in
                // TODO: Authroziation save to keychain
            })
            .map { $0.localId }
            .map { User(id: $0, user: user) }
            .flatMap { userRepository.create(user: $0) }
            .do(onNext: {
                _ = userRepository.save(user: $0)
            })
            .map { _ in }
    }
}
