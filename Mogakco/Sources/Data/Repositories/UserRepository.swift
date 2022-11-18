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
    private let disposeBag = DisposeBag()
    
    init(localUserDataSource: LocalUserDataSourceProtocol) {
        self.localUserDataSource = localUserDataSource
    }

    func save(user: User) -> Observable<Void> {
        return localUserDataSource.save(user: user)
    }
}
