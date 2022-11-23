//
//  UserRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct UserRepository: UserRepositoryProtocol {
  
    private var localUserDataSource: LocalUserDataSourceProtocol
    private var remoteUserDataSource: RemoteUserDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        localUserDataSource: LocalUserDataSourceProtocol,
        remoteUserDataSource: RemoteUserDataSourceProtocol
    ) {
        self.localUserDataSource = localUserDataSource
        self.remoteUserDataSource = remoteUserDataSource
    }

    func save(user: User) -> Observable<Void> {
        return localUserDataSource.save(user: user)
    }
    
    func save(userUID: String) -> Observable<Void> {
        return localUserDataSource.saveUID(userUID: userUID)
    }
    
    func user(id: String) -> Observable<User> {
        return remoteUserDataSource.user(id: id)
            .map { $0.toDomain() }
    }
    
    func load() -> Observable<User> {
        return localUserDataSource.load()
    }
    
    func create(user: User, imageData: Data) -> Observable<User> {
        return remoteUserDataSource.uploadProfileImage(id: user.id, imageData: imageData)
            .map { $0.absoluteString }
            .map { User(profileImageURLString: $0, user: user) }
            .map { UserRequestDTO(user: $0) }
            .flatMap { remoteUserDataSource.create(request: $0) }
            .map { $0.toDomain() }
    }
    
    func editProfile(id: String, name: String, introduce: String, imageData: Data) -> Observable<User> {
        return remoteUserDataSource.uploadProfileImage(id: id, imageData: imageData)
            .map { $0.absoluteString }
            .map { EditProfileRequestDTO(name: name, introduce: introduce, profileImageURLString: $0) }
            .flatMap { remoteUserDataSource.editProfile(id: id, request: $0) }
            .map { $0.toDomain() }
    }
}
 
