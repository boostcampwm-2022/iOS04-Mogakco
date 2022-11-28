//
//  ChatRoom.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct ChatRoom {
    let id: String
    let studyID: String?
    let userIDs: [String]
    let latestChat: Chat?
    let unreadChatCount: Int?
    let users: [User]?
}

extension ChatRoom {
    init(chatRoom: ChatRoom, latestChat: Chat?, unreadChatCount: Int) {
        self.id = chatRoom.id
        self.studyID = chatRoom.studyID
        self.userIDs = chatRoom.userIDs
        self.latestChat = latestChat
        self.unreadChatCount = unreadChatCount
        self.users = nil
    }
    
    init(chatRoom: ChatRoom, users: [User]) {
        self.id = chatRoom.id
        self.studyID = chatRoom.studyID
        self.userIDs = chatRoom.userIDs
        self.latestChat = chatRoom.latestChat
        self.unreadChatCount = chatRoom.unreadChatCount
        self.users = users
    }
}
