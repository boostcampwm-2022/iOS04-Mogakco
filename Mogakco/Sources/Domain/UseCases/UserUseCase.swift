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
    
    func users(ids: [String]) -> Observable<[User]> {
        return userRepository.allUsers()
            .map {
                var filteredUser: [User] = []
                $0.forEach { user in
                    guard let id = user.id else { return }
                    if ids.contains(id) { filteredUser.append(user) }
                }
                return filteredUser
            }
	}

    func myProfile() -> Observable<User> {
        return userRepository.load()
            .compactMap { $0.id }
            .flatMap { userRepository.user(id: $0) }
			.flatMap { userRepository.save(user: $0) }
    }
}
