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
}

extension ChatRoom {
    init(chatRoom: ChatRoom, latestChat: Chat?, unreadChatCount: Int) {
        self.id = chatRoom.id
        self.studyID = chatRoom.studyID
        self.userIDs = chatRoom.userIDs
        self.latestChat = latestChat
        self.unreadChatCount = unreadChatCount
    }
}
