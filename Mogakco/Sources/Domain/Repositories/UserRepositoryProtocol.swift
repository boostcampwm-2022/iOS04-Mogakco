//
//  UserRepositoryProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol UserRepositoryProtocol {
    func save(user: User) -> Observable<Void>
    func save(userID: String) -> Observable<Void>
    func user(id: String) -> Observable<User>
    func allUsers() -> Observable<[User]>
    func load() -> Observable<User>
    func create(user: User, imageData: Data) -> Observable<User>
    func delete(id: String) -> Observable<Void>
    func editProfile(id: String, name: String, introduce: String, imageData: Data) -> Observable<User>
    func editLanguages(id: String, languages: [String]) -> Observable<User>
    func editCareers(id: String, careers: [String]) -> Observable<User>
    func editCategorys(id: String, categorys: [String]) -> Observable<User>
    func updateIDs(id: String, chatRoomIDs: [String], studyIDs: [String]) -> Observable<User>
}
