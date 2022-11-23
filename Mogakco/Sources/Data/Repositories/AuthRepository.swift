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
    
    func signup(user: User) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(user: user)
        return authService.signup(request)
            .map { $0.toDomain() }
    }
    
    func login(emailLogin: EmailLogin) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(emailLogin: emailLogin)
        return authService.login(request)
            .map { $0.toDomain() }
    }
}
