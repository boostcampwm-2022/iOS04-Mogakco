//
//  ChatRepository.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatRepository: ChatRepositoryProtocol {
    private let chatDataSource: ChatDataSourceProtocol
    private let disposeBag = DisposeBag()

    init(
        chatDataSource: ChatDataSourceProtocol
    ) {
        self.chatDataSource = chatDataSource
    }

    func fetch(chatRoomID: String) -> Observable<[Chat]> {
        return chatDataSource.fetch(chatRoomID: chatRoomID).map { $0.map { $0.toDomain() } }
    }

    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return chatDataSource.send(chat: chat, to: chatRoomID)
            // TODO: ChatService 객체 만들어야 할 듯
    }
}
