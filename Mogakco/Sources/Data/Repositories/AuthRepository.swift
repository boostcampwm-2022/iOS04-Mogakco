//
//  AuthRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct AuthRepository: AuthRepositoryProtocol {
    
    var authService: AuthServiceProtocol?
    private let disposeBag = DisposeBag()
    
    func signup(signupProps: SignupProps) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(signupProps: signupProps)
        return authService?.signup(request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func login(emailLogin: EmailLogin) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(emailLogin: emailLogin)
        return authService?.login(request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func withdraw(idToken: String) -> Observable<Void> {
        let request = WithdrawRequestDTO(idToken: idToken)
        return authService?
            .withdraw(request)
            .map { _ in } ?? .empty()
    }
}
