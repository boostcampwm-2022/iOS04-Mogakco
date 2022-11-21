//
//  SignupRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct SignupRequestDTO: Encodable {
    // TODO: private
    let email: String
    let password: String
    let name: String
    let languages: [String]
    let careers: [String]
    
    init(user: User) {
        self.email = user.email
        self.password = user.password ?? ""
        self.name = user.name
        self.languages = user.languages
        self.careers = user.careers
    }
}
