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


    func fetch(chatRoomID: String) -> Observable<[Chat]> {
        return chatRepository.fetch(chatRoomID: chatRoomID)
    }

    func send(chat: Chat, to chatRoomID: String) -> Observable<Error?> {
        return chatRepository.send(chat: chat, to: chatRoomID)
    }
    
    func myProfile() -> Observable<User> {
        return userRepository.load()
    }
}
