//
//  ChatRepository.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct ChatRepository: ChatRepositoryProtocol {
    
    var chatDataSource: ChatDataSourceProtocol?
    var reportDataSource: ReportDataSourceProtocol?
    var pushNotificationService: PushNotificationServiceProtocol?
    private let disposeBag = DisposeBag()

    func fetch(chatRoomID: String) -> Observable<[Chat]> {
        return chatDataSource?.fetch(chatRoomID: chatRoomID).map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func observe(chatRoomID: String) -> Observable<Chat> {
        let chat = chatDataSource?.observe(chatRoomID: chatRoomID)
            .map { $0.toDomain() } ?? .empty()
        
        return Observable.combineLatest(chat, reportDataSource?.loadUser() ?? .empty())
            .filter { chat, reportIds in
                !reportIds.contains(chat.userID)
            }
            .map { $0.0 }
    }

    func send(chat: Chat) -> Observable<Void> {
        let request = ChatRequestDTO(chat: chat)
        return chatDataSource?.send(request: request)
            .map { _ in
                PushNotificationRequestDTO(
                    topic: chat.chatRoomID,
                    title: chat.user?.name ?? "",
                    body: chat.message
                )
            }
            .flatMap { pushNotificationService?.sendTopic(request: $0) ?? .empty() }
            .map { _ in () } ?? .empty()
    }
    
    func read(chat: Chat) -> Observable<Void> {
        return chatDataSource?.read(chat: chat) ?? .empty()
    }
    
    func stopObserving() {
        chatDataSource?.stopObserving()
    }
}
