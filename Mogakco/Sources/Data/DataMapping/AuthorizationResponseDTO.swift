//
//  AuthorizationResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct AuthorizationResponseDTO: Decodable {
    private let idToken: String
    private let email: String
    private let refreshToken: String
    private let expiresIn: String
    private let localId: String
    
    func toDomain() -> Authorization {
        return Authorization(
            idToken: idToken,
            email: email,
            refreshToken: refreshToken,
            expiresIn: expiresIn,
            localId: localId
        )
    }
}
