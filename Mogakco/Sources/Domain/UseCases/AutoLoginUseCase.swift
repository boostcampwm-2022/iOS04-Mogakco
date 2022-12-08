//
//  AutoLoginUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct AutoLoginUseCase: AutoLoginUseCaseProtocol {
    
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func load() -> Observable<Bool> {
        return tokenRepository?.load()
            .map { $0 != nil } ?? .empty()
    }
}
