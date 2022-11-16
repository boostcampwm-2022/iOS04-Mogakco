//
//  SignupRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol SignupRepository {
    func signup(email: String, password: String) -> Single<Result<Void, Error>>
}
