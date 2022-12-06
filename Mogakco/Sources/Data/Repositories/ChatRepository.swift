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

    func fetchAll(chatRoomID: String) -> Observable<[Chat]> {
        let chats = chatDataSource?.fetchAll(chatRoomID: chatRoomID)
            .map { $0.map { $0.toDomain() } } ?? .empty()
        
        return Observable.combineLatest(chats, reportDataSource?.loadUser() ?? .empty())
            .map { chats, reportIds in
                chats.filter { !reportIds.contains($0.userID) }
            }
    }
    
    func reload(chatRoomID: String) -> Observable<[Chat]> {
        let chats = chatDataSource?.reload(chatRoomID: chatRoomID)
            .map { $0.map { $0.toDomain() } } ?? .empty()
        
        return Observable.combineLatest(chats, reportDataSource?.loadUser() ?? .empty())
            .map { chats, reportIds in
                chats.filter { !reportIds.contains($0.userID) }
            }
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
