//
//  ChatRepository.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatRepository: ChatRepositoryProtocol {
    var chatDataSource: ChatDataSourceProtocol?
    var pushNotificationService: PushNotificationServiceProtocol?
    private let disposeBag = DisposeBag()

    func fetchAll(chatRoomID: String) -> Observable<[Chat]> {
        return chatDataSource?.fetchAll(chatRoomID: chatRoomID).map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func reload(chatRoomID: String) -> Observable<[Chat]> {
        return chatDataSource?.reload(chatRoomID: chatRoomID).map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func observe(chatRoomID: String) -> Observable<Chat> {
        return chatDataSource?.observe(chatRoomID: chatRoomID).map { $0.toDomain() } ?? .empty()
    }

    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        let request = PushNotificationRequestDTO(
            topic: chatRoomID,
            title: chat.user?.name ?? "",
            body: chat.message)
        return chatDataSource?.send(chat: chat, to: chatRoomID)
            .flatMap { pushNotificationService?.sendTopic(request: request) ?? .empty() }
            .map { _ in () } ?? .empty()
    }
}
