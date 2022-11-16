//
//  SignupDataSourceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol SignupDataSourceProtocol {
    func signup(_ request: SignupRequestDTO) -> Single<Result<SignupResponseDTO, Error>>
}
