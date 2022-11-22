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
        let request = UserRequestDTO(id: id)
        return remoteUserDataSource.user(request: request)
            .map { $0.toDomain() }
    }
    
    func load() -> Observable<User> {
        return localUserDataSource.load()
    }
    
    func editProfile(id: String, name: String, introduce: String, imageData: Data) -> Observable<User> {
        return remoteUserDataSource.uploadProfileImage(id: id, imageData: imageData)
            .map { $0.absoluteString }
            .map { EditProfileRequestDTO(name: name, introduce: introduce, profileImageURLString: $0) }
            .flatMap { remoteUserDataSource.editProfile(id: id, request: $0) }
            .map { $0.toDomain() }
    }
}
 
