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

    func fetchAll(chatRoomID: String) -> Observable<Chat> {
        return chatDataSource.fetchAll(chatRoomID: chatRoomID).map { $0.toDomain() }
    }
    
    func reload(chatRoomID: String) -> Observable<Chat> {
        return chatDataSource.reload(chatRoomID: chatRoomID).map { $0.toDomain() }
    }
    
    func observe(chatRoomID: String) -> Observable<Chat> {
        return chatDataSource.observe(chatRoomID: chatRoomID).map { $0.toDomain() }
    }

    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return chatDataSource.send(chat: chat, to: chatRoomID)
            // TODO: ChatService 객체 만들어야 할 듯
    }
}
