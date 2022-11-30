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
    
    func fetchAll(chatRoomID: String) -> Observable<Chat> {
        return chatRepository
            .fetchAll(chatRoomID: chatRoomID)
            .flatMap {
                var chat = $0
                return Observable.combineLatest(
                    userRepository.user(id: chat.userID),
                    userRepository.load()
                )
                .map { chatUserData, myUserData in
                    chat.user = chatUserData
                    chat.isFromCurrentUser = chatUserData.id == myUserData.id
                    return chat
                }
            }
    }
    
    func reload(chatRoomID: String) -> Observable<Chat> {
        return chatRepository
            .reload(chatRoomID: chatRoomID)
            .flatMap {
                var chat = $0
                return Observable.combineLatest(
                    userRepository.user(id: chat.userID),
                    userRepository.load()
                )
                .map { chatUserData, myUserData in
                    chat.user = chatUserData
                    chat.isFromCurrentUser = chatUserData.id == myUserData.id
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
                .map { chatUserData, myUserData in
                    chat.user = chatUserData
                    chat.isFromCurrentUser = chatUserData.id == myUserData.id
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
