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
  
    enum UserRepositoryError: Error {
        case noFcmToken
    }
    
    var localUserDataSource: LocalUserDataSourceProtocol?
    var remoteUserDataSource: RemoteUserDataSourceProtocol?
    var keyChainManager: KeychainManagerProtocol?
    private let disposeBag = DisposeBag()

    func save(user: User) -> Observable<Void> {
        return localUserDataSource?.save(user: user) ?? .empty()
    }
    
    func save(userID: String) -> Observable<Void> {
        return localUserDataSource?.saveID(userID: userID) ?? .empty()
    }
    
    func user(id: String) -> Observable<User> {
        return remoteUserDataSource?.user(id: id)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func allUsers() -> Observable<[User]> {
        return remoteUserDataSource?.allUsers()
            .map { $0.documents.map { $0.toDomain() } } ?? .empty()
    }
    
    func load() -> Observable<User> {
        return localUserDataSource?.load() ?? .empty()
    }
    
    func create(user: User, imageData: Data) -> Observable<User> {
        var fcmToken = ""
        if let loadedFcmTokenData = keyChainManager?.load(key: .fcmToken),
            let loadedFcmToken = String(data: loadedFcmTokenData, encoding: .utf8) {
            fcmToken = loadedFcmToken
        }
        return remoteUserDataSource?.uploadProfileImage(id: user.id, imageData: imageData)
            .map { $0.absoluteString }
            .map { User(profileImageURLString: $0, fcmToken: fcmToken, user: user) }
            .map { UserRequestDTO(user: $0) }
            .flatMap { remoteUserDataSource?.create(request: $0) ?? .empty() }
            .map { $0.toDomain() } ?? .empty()
    }
    
    func delete(id: String) -> Observable<Void> {
        print("DELETE : UserRepository \(id)")
        return remoteUserDataSource?.delete(id)
            .map { _ in } ?? .empty()
    }
    
    func editProfile(
        id: String,
        name: String,
        introduce: String,
        imageData: Data
    ) -> Observable<User> {
        return remoteUserDataSource?.uploadProfileImage(id: id, imageData: imageData)
            .map { $0.absoluteString }
            .map {
                EditProfileRequestDTO(
                    name: name,
                    introduce: introduce,
                    profileImageURLString: $0
                )
            }
            .flatMap { remoteUserDataSource?.editProfile(id: id, request: $0) ?? .empty() }
            .map { $0.toDomain() } ?? .empty()
    }
    
    func editLanguages(id: String, languages: [String]) -> Observable<User> {
        let request = EditLanguagesRequestDTO(languages: languages)
        return remoteUserDataSource?.editLanguages(id: id, request: request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func editCareers(id: String, careers: [String]) -> Observable<User> {
        let request = EditCareersRequestDTO(careers: careers)
        return remoteUserDataSource?.editCareers(id: id, request: request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func editCategorys(id: String, categorys: [String]) -> Observable<User> {
        let request = EditCategorysRequestDTO(categorys: categorys)
        return remoteUserDataSource?.editCategorys(id: id, request: request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func updateIDs(
        id: String,
        chatRoomIDs: [String],
        studyIDs: [String]
    ) -> Observable<User> {
        let request = UpdateStudyIDsRequestDTO(chatRoomIDs: chatRoomIDs, studyIDs: studyIDs)
        return remoteUserDataSource?.updateIDs(id: id, request: request)
            .map { $0.toDomain() } ?? .empty()
    }
}
 
