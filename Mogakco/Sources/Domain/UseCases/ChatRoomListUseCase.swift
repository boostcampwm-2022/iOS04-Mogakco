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

    var chatRoomRepository: ChatRoomRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func chatRooms() -> Observable<[ChatRoom]> {
        let user = userRepository?.load() ?? .empty()
        return user
            .flatMap { chatRoomRepository?.list(id: $0.id, ids: $0.chatRoomIDs) ?? .empty() }
            .withLatestFrom(user) { chatRooms, user in
                return chatRooms.map { chatRoom in
                    ChatRoom(chatRoom: chatRoom, users: chatRoom.users?.filter { $0.id != user.id } ?? [])
                }
            }
    }
    
    func leave(chatRoom: ChatRoom) -> Observable<Void> {
        return userRepository?.load()
            .flatMap { chatRoomRepository?.leave(user: $0, chatRoom: chatRoom) ?? .empty() }
            .flatMap { userRepository?.save(user: $0) ?? .empty() } ?? .empty()
    }
}
