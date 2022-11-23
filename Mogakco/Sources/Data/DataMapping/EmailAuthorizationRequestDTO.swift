//
//  EmailAuthorization.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct EmailAuthorizationRequestDTO: Encodable {
    private let email: String
    private let password: String
    private let returnSecureToken: Bool
    
    init(user: User) {
        self.email = user.email
        self.password = user.password ?? ""
        self.returnSecureToken = true
    }
    
    init(emailLogin: EmailLogin) {
        self.email = emailLogin.email
        self.password = emailLogin.password
        self.returnSecureToken = true
    }
}
