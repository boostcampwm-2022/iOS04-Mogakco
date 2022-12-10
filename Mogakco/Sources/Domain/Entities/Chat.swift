//
//  Chat.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct Chat: Codable {
    let id: String
    let userID: String
    let message: String
    let chatRoomID: String
    let date: Int
    var readUserIDs: [String]
    var user: User?
    var isFromCurrentUser: Bool?
}
