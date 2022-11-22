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
    let profileImageURLString: String
    let email: String
    let password: String
    let name: String
    let introduce: String
    let languages: [String]
    let careers: [String]
    let categorys: [String]
    let studyIDs: [String]
    let chatRoomIDs: [String]
    
    init(user: User) {
        self.profileImageURLString = user.profileImageURLString
        self.email = user.email
        self.password = user.password ?? ""
        self.name = user.name
        self.introduce = user.introduce
        self.languages = user.languages
        self.careers = user.careers
        self.categorys = user.categorys
        self.studyIDs = user.studyIDs
        self.chatRoomIDs = user.chatRoomIDs
    }
}
