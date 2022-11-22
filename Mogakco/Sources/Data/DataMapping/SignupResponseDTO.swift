//
//  SignupResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct SignupResponseDTO: Decodable {
    // TODO: private
    let id: String
    let email: String
    let name: String
    let introduce: String
    let languages: [String]
    let careers: [String]
    let categorys: [String]
    let studyIDs: [String]
    let chatRoomIDs: [String]
    
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            introduce: introduce,
            password: nil,
            name: name,
            languages: languages,
            careers: careers,
            categorys: categorys,
            studyIDs: studyIDs,
            chatRoomIDs: chatRoomIDs
        )
    }
}
