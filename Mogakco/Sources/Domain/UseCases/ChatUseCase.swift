//
//  ChatUseCase.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/27.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatUseCase: ChatUseCaseProtocol {

    private let chatRepository: ChatRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(
        chatRepository: ChatRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.chatRepository = chatRepository
        self.userRepository = userRepository
    }
    
    func fetchAll(chatRoomID: String) -> Observable<[Chat]> {
        let users = userRepository.allUsers()
        let myUser = userRepository.load()
        let chats = chatRepository.fetchAll(chatRoomID: chatRoomID)
        return Observable.zip(users, myUser, chats)
            .map { users, myUser, chats in
                return chats.map {
                    var chat = $0
                    chat.user = users.filter { user in
                        user.id == myUser.id
                    }.first
                    chat.isFromCurrentUser = chat.userID == myUser.id
                    return chat
                }
            }
    }
    
    func reload(chatRoomID: String) -> Observable<[Chat]> {
        let users = userRepository.allUsers()
        let myUser = userRepository.load()
        let chats = chatRepository.reload(chatRoomID: chatRoomID)
        return Observable.zip(users, myUser, chats)
            .map { users, myUser, chats in
                return chats.map {
                    var chat = $0
                    chat.user = users.filter {
                        $0.id == myUser.id
                    }.first
                    chat.isFromCurrentUser = chat.userID == myUser.id
                    return chat
                }
            }
    }
    
    func observe(chatRoomID: String) -> Observable<Chat> {
        return chatRepository
            .observe(chatRoomID: chatRoomID)
            .flatMap {
                var chat = $0
                return Observable.combineLatest(
                    userRepository.user(id: chat.userID),
                    userRepository.load()
                )
                .map { chatUser, myUser in
                    chat.user = chatUser
                    chat.isFromCurrentUser = chatUser.id == myUser.id
                    return chat
                }
            }
    }
    
    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return chatRepository.send(chat: chat, to: chatRoomID)
    }
    
    func myProfile() -> Observable<User> {
        return userRepository.load()
    }
}
