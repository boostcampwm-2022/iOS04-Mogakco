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
    func save(userUID: String) -> Observable<Void>
    func user(id: String) -> Observable<User>
    func load() -> Observable<User>
    func editProfile(id: String, name: String, introduce: String, imageData: Data) -> Observable<User>
}
