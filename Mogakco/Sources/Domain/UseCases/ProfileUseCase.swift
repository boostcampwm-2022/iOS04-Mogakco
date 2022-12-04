//
//  ProfileUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ProfileUseCase: ProfileUseCaseProtocol {

    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func profile() -> Observable<User> {
        return userRepository?.load()
            .compactMap { $0.id }
            .flatMap { userRepository?.user(id: $0) ?? .empty() }
            .do(onNext: {
                _ = userRepository?.save(user: $0)
            }) ?? .empty()
    }
}
