//
//  CreateChatRoomUseCaseProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateChatRoomUseCaseProtocol {
    func create(otherUser: User) -> Observable<ChatRoom>
}
