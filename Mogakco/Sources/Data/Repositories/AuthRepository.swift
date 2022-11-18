//
//  AuthRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct AuthRepository: AuthRepositoryProtocol {

    private var authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func signup(user: User) -> Observable<User> {
        let request = SignupRequestDTO(
            email: user.email,
            password: user.password ?? "", // TODO: handling
            name: user.name,
            languages: user.languages,
            careers: user.careers
        )
        return authService
            .signup(request)
            .map { $0.toDomain() }
    }
}
