//
//  UserRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct UserRepository: UserRepositoryProtocol {

    private var localUserDataSource: LocalUserDataSourceProtocol
    private var userDataSource: UserDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        localUserDataSource: LocalUserDataSourceProtocol,
        userDataSource: UserDataSourceProtocol
    ) {
        self.localUserDataSource = localUserDataSource
        self.userDataSource = userDataSource
    }

    func save(user: User) -> Observable<Void> {
        return localUserDataSource.save(user: user)
    }
    
    func user(id: String) -> Observable<User> {
        let request = UserRequestDTO(id: id)
        return userDataSource.user(request: request)
            .map { $0.toDomain() }
    }
    
    func load() -> Observable<User> {
        return localUserDataSource.load()
    }
}
