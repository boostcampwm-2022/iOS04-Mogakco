//
//  AuthServiceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol AuthServiceProtocol {
    func signup(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO>
    func login(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO>
}
