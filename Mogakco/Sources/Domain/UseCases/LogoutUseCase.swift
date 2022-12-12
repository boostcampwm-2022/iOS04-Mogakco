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
    var pushNotificationService: PushNotificationService?
    private let disposeBag = DisposeBag()
    
    func logout() -> Observable<Void> {
        return tokenRepository?.delete()
            .flatMap { _ in pushNotificationService?.deleteToken() ?? .empty() } ?? .empty()
    }
}
