//
//  User.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

struct User: Codable {
    let id: String?
    let email: String
    let introduce: String
    let password: String?
    let name: String
    let languages: [String]
    let careers: [String]
    let categorys: [String]
    // TODO: Image
}
