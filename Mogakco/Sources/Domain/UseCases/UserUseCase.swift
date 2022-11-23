//
//  UserUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct UserUseCase: UserUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func user(id: String) -> Observable<User> {
        return userRepository.user(id: id)
    }
    
    func myProfile() -> Observable<User> {
        return userRepository.load()
            .compactMap { $0.id }
            .flatMap { userRepository.user(id: $0) }
            .do(onNext: {
                _ = userRepository.save(user: $0)
            })
    }
}
