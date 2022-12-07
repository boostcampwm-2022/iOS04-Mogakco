//
//  LogoutUseCase.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct LogoutUseCase: LogoutUseCaseProtocol {
    
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func logout() -> Observable<Void> {
        return tokenRepository?.load()
            .compactMap { $0 }
            .flatMap { tokenRepository?.delete($0) ?? .empty() }
            .map { _ in } ?? .empty()
    }
}
