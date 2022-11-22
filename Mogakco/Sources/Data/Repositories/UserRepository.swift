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
    private var retmoteUserDataSource: RemoteUserDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        localUserDataSource: LocalUserDataSourceProtocol,
        retmoteUserDataSource: RemoteUserDataSourceProtocol
    ) {
        self.localUserDataSource = localUserDataSource
        self.retmoteUserDataSource = retmoteUserDataSource
    }

    func save(user: User) -> Observable<Void> {
        return localUserDataSource.save(user: user)
    }
    
    func save(userUID: String) -> Observable<Void> {
        return localUserDataSource.saveUID(userUID: userUID)
    }
    
    func user(id: String) -> Observable<User> {
        let request = UserRequestDTO(id: id)
        return retmoteUserDataSource.user(request: request)
            .map { $0.toDomain() }
    }
    
    func load() -> Observable<User> {
        return localUserDataSource.load()
    }
    
    func editProfile(id: String, name: String, introduce: String) -> Observable<User> {
        let request = EditProfileRequestDTO(name: name, introduce: introduce)
        return retmoteUserDataSource.editProfile(id: id, request: request)
            .map { $0.toDomain() }
    }
}
 
