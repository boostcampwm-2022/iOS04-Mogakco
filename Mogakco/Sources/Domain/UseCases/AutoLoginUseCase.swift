//
//  AutoLoginUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

final class AutoLoginUseCase: AutoLoginUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    private let tokenRepository: TokenRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepositoryProtocol,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.tokenRepository = tokenRepository
    }
    
    func load() -> Observable<Bool> {
        
        return Observable.create { [weak self] emitter in
            
            guard let self = self else { return Disposables.create() }
            let token = PublishSubject<User>()

            token
                .debug()
                .flatMap { self.tokenRepository.load(email: $0.email) }
                .map { $0 != nil }
                .bind(to: emitter)
                .disposed(by: self.disposeBag)
            
            self.userRepository.load()
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
