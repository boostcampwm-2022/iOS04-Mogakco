//
//  EditProfileUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct EditProfileUseCase: EditProfileUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func editProfile(name: String, introduce: String) -> Observable<Void> {
        return userRepository
            .load()
            .compactMap { $0.id }
            .flatMap { userRepository.editProfile(id: $0, name: name, introduce: introduce) }
            .flatMap { userRepository.save(user: $0) }
    }
}
