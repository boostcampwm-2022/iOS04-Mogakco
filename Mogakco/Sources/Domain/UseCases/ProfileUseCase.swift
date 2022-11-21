//
//  ProfileUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ProfileUseCase: ProfileUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func profile() -> Observable<User> {
        
        userRepository.load()
            .subscribe(onNext: { user in
                dump(user)
            }) 
        
        return userRepository.load()
            .compactMap { $0.id }
            .flatMap { userRepository.user(id: $0) }
    }
}
