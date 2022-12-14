//
//  ChatUseCase.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatUseCase: ChatUseCaseProtocol {

    var chatRepository: ChatRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func fetch(chatRoomID: String) -> Observable<[Chat]> {
        let users = userRepository?.allUsers() ?? .empty()
        let myUser = userRepository?.load() ?? .empty()
        let chats = chatRepository?.fetch(chatRoomID: chatRoomID) ?? .empty()
        return Observable.zip(users, myUser, chats)
            .map { users, myUser, chats in
                return chats.map {
                    var chat = $0
                    chat.user = users.first(where: {
                        $0.id == chat.userID
                    })
                    chat.isFromCurrentUser = chat.userID == myUser.id
                    return chat
                }
            }
    }
    
    func observe(chatRoomID: String) -> Observable<Chat> {
        return chatRepository?
            .observe(chatRoomID: chatRoomID)
            .flatMap {
                var chat = $0
                return Observable.combineLatest(
                    userRepository?.user(id: chat.userID) ?? .empty(),
                    userRepository?.load() ?? .empty()
                )
                .map { chatUser, myUser in
                    chat.user = chatUser
                    chat.isFromCurrentUser = chatUser.id == myUser.id
                    return chat
                }
                .catchAndReturn(chat)
            } ?? .empty()
    }
    
    func send(chat: Chat) -> Observable<Void> {
        return chatRepository?.send(chat: chat) ?? .empty()
    }
    
    func read(chat: Chat, userID: String) -> Observable<Void> {
        if chat.readUserIDs.contains(userID) { return Observable.just(()) }
        let newChat = Chat(
            id: chat.id,
            userID: chat.userID,
            message: chat.message,
            chatRoomID: chat.chatRoomID,
            date: chat.date,
            readUserIDs: chat.readUserIDs + [userID]
        )
        return chatRepository?.read(chat: newChat) ?? .empty()
    }
    
    func stopObserving() {
        chatRepository?.stopObserving()
    }
    
    func myProfile() -> Observable<User> {
        return userRepository?.load() ?? .empty()
    }
}
