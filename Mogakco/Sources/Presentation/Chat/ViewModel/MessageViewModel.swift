//
//  MessageViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/20.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor? {
        return message.isFromCurrentUser ? .mogakcoColor.primarySecondary : .mogakcoColor.backgroundSecondary
    }
    
    var messageTextColor: UIColor? {
        return .mogakcoColor.typographyPrimary
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    init(message: Message) {
        self.message = message
    }
}

struct Message {
    let isFromCurrentUser: Bool
    let text: String
}
