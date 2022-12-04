//
//  AutoLoginUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct AutoLoginUseCase: AutoLoginUseCaseProtocol {
    
    var userRepository: UserRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func load() -> Observable<Bool> {
        return Observable.create { emitter in
            let token = PublishSubject<User>()

            token
                .flatMap { self.tokenRepository?.load(email: $0.email) ?? .empty() }
                .map { $0 != nil }
                .bind(to: emitter)
                .disposed(by: self.disposeBag)
            
            self.userRepository?.load()
                .subscribe(onNext: {
                    token.onNext($0)
                }, onError: { _ in
                    emitter.onNext(false)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
