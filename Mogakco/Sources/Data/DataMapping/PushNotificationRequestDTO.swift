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
}
