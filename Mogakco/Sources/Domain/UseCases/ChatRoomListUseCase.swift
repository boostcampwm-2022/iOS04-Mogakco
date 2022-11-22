//
//  ChatRoomListUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatRoomListUseCase: ChatRoomListUseCaseProtocol {

    private let chatRoomRepository: ChatRoomRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        chatRoomRepository: ChatRoomRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.chatRoomRepository = chatRoomRepository
        self.userRepository = userRepository
    }
    
    func chatRooms() -> Observable<[ChatRoom]> {
        return userRepository
            .load()
            .compactMap { $0.chatRoomIDs }
            .flatMap { chatRoomRepository.list(ids: $0) }
    }
}
