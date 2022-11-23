//
//  Authorization.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct Authorization: Encodable {
    let idToken: String
    let email: String
    let refreshToken: String
    let expiresIn: String
    let localId: String
}
