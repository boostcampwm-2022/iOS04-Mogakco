//
//  User.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

struct User: Codable {
    let id: String
    let profileImageURLString: String?
    let email: String
    let introduce: String
    let password: String?
    let name: String
    let languages: [String]
    let careers: [String]
    let categorys: [String]
    let studyIDs: [String]
    let chatRoomIDs: [String]
}

extension User {
    init(id: String, signupProps: SignupProps) {
        self.id = id
        self.profileImageURLString = nil
        self.email = signupProps.email
        self.introduce = signupProps.introduce
        self.password = nil
        self.name = signupProps.name
        self.languages = signupProps.languages
        self.careers = signupProps.careers
        self.categorys = []
        self.studyIDs = []
        self.chatRoomIDs = []
    }
    
    init(profileImageURLString: String, user: User) {
        self.id = user.id
        self.profileImageURLString = profileImageURLString
        self.email = user.email
        self.introduce = user.introduce
        self.password = user.password
        self.name = user.name
        self.languages = user.languages
        self.careers = user.careers
        self.categorys = user.categorys
        self.studyIDs = user.studyIDs
        self.chatRoomIDs = user.chatRoomIDs
    }
}
