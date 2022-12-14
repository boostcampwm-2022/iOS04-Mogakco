//
//  ChatUseCaseProtocol.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ChatUseCaseProtocol {
    func fetch(chatRoomID: String) -> Observable<[Chat]>
    func observe(chatRoomID: String) -> Observable<Chat>
    func send(chat: Chat) -> Observable<Void>
    func read(chat: Chat, userID: String) -> Observable<Void>
    func stopObserving()
    func myProfile() -> Observable<User> 
}
