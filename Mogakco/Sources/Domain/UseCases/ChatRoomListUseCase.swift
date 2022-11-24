//
//  ChatRoomListUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct ChatRoomListUseCase: ChatRoomListUseCaseProtocol {
    
    enum ChatRoomListUseCaseError: Error, LocalizedError {
        case nonUserID
    }

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
            .flatMap { user in
                guard let id = user.id else {
                    return Observable<[ChatRoom]>.error(ChatRoomListUseCaseError.nonUserID)
                }
                return chatRoomRepository.list(id: id, ids: user.chatRoomIDs)
            }
    }
}
