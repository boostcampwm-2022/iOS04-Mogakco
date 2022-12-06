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

    func fetchAll(chatRoomID: String) -> Observable<[Chat]> {
        let users = userRepository?.allUsers() ?? .empty()
        let myUser = userRepository?.load() ?? .empty()
        let chats = chatRepository?.fetchAll(chatRoomID: chatRoomID) ?? .empty()
        return Observable.zip(users, myUser, chats)
            .map { users, myUser, chats in
                return chats.map {
                    var chat = $0
                    chat.user = users.first(where: { user in
                        return user.id == chat.userID
                    })
                    chat.isFromCurrentUser = chat.userID == myUser.id
                    return chat
                }
            }
    }
    
    func reload(chatRoomID: String) -> Observable<[Chat]> {
        let users = userRepository?.allUsers() ?? .empty()
        let myUser = userRepository?.load() ?? .empty()
        let chats = chatRepository?.reload(chatRoomID: chatRoomID) ?? .empty()
        return Observable.zip(users, myUser, chats)
            .map { users, myUser, chats in
                return chats.map {
                    var chat = $0
                    chat.user = users.first(where: { user in
                        return user.id == chat.userID
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
            } ?? .empty()
    }
    
    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return chatRepository?.send(chat: chat, to: chatRoomID) ?? .empty()
    }
    
    func myProfile() -> Observable<User> {
        return userRepository?.load() ?? .empty()
    }
}
