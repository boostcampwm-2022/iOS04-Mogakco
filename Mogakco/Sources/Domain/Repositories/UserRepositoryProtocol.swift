//
//  UserRepositoryProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol UserRepositoryProtocol {
    func save(user: User) -> Observable<Void>
    func user(id: String) -> Observable<User>
    func load() -> Observable<User>
}
