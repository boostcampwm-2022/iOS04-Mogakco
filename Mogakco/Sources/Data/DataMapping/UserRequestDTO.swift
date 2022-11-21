//
//  UserRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UserRequestDTO: Encodable {
    let id: String
    
    init(id: String) {
        self.id = id
    }
}
