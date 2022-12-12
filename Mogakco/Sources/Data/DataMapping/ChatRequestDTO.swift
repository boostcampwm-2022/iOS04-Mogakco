//
//  ChatRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/12.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct ChatRequestDTO: Encodable {
    let id: String
    let userID: String
    let message: String
    let chatRoomID: String
    let date: Int
    let readUserIDs: [String]
    
    init(chat: Chat) {
        self.id = chat.id
        self.userID = chat.userID
        self.message = chat.message
        self.chatRoomID = chat.chatRoomID
        self.date = chat.date
        self.readUserIDs = chat.readUserIDs
    }
}
