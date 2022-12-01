//
//  ChatUseCaseProtocol.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ChatUseCaseProtocol {
    func fetchAll(chatRoomID: String) -> Observable<[Chat]>
    func reload(chatRoomID: String) -> Observable<[Chat]>
    func observe(chatRoomID: String) -> Observable<Chat>
    func send(chat: Chat, to chatRoomID: String) -> Observable<Void>
    func myProfile() -> Observable<User> 
}
