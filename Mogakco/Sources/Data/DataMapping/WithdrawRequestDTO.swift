//
//  WithdrawRequestDTO.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct WithdrawRequestDTO: Codable {
    let idToken: String
    
    init(idToken: String) {
        self.idToken = idToken
    }
}
