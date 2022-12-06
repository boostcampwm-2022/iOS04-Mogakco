//
//  PushNotificationRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct PushNotificationRequestDTO: Encodable {
    struct Notification: Encodable {
        let title: String
        let body: String
    }
    let to: String
    let notification: Notification
    
    init(token: String, title: String, body: String) {
        self.to = token
        self.notification = .init(title: title, body: body)
    }
    
    init(topic: String, title: String, body: String) {
        self.to = "/topics/\(topic)"
        self.notification = .init(title: title, body: body)
    }
}
