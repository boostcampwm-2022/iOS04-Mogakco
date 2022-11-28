//
//  Study.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct Study {
    let id: String
    let chatRoomID: String
    var userIDs: [String]
    let title: String
    let content: String
    let date: Int
    let place: String
    let maxUserCount: Int
    let languages: [String]
    let category: String
}

extension Study {
    init(study: Study, userIDs: [String]) {
        self.id = study.id
        self.chatRoomID = study.chatRoomID
        self.userIDs = userIDs
        self.title = study.title
        self.content = study.content
        self.date = study.date
        self.place = study.place
        self.maxUserCount = study.maxUserCount
        self.languages = study.languages
        self.category = study.category
    }
}
