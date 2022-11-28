//
//  ChatRepositoryProtocol.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ChatRepositoryProtocol {
    func fetch(chatRoomID: String) -> Observable<[Chat]>
    func send(chat: Chat, to chatRoomID: String) -> Observable<Error?> // Chat으로?
}