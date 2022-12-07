//
//  WithdrawUseCase.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

final class WithdrawUseCase: WithdrawUseCaseProtocol {
    
    var userRepository: UserRepositoryProtocol?
    var authRepository: AuthRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func withdraw(email: String) -> Observable<Void> {
        print("DEBUG : withdrawUseCase Called \(email)")
        return tokenRepository?.load()
            .compactMap { $0 }
            .flatMap {
                 self.authRepository?
                    .withdraw(idToken: $0.idToken) ?? .empty()
            } ?? .empty()
    }
    
    func delete() -> Observable<Void> {
        return userRepository?.load()
            .flatMap { [weak self] user in
                self?.userRepository?.delete(id: user.id) ?? .empty()
            } ?? .empty()
    }
}
