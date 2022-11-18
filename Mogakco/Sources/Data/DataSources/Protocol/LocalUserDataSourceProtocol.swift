//
//  LocalUserDataSourceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol LocalUserDataSourceProtocol {
    func save(user: User) -> Observable<Void>
    func load() -> Observable<User>
    func remove() -> Observable<Void>
}
