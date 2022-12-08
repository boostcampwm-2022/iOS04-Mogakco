//
//  CreateChatRoomUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct CreateChatRoomUseCase: CreateChatRoomUseCaseProtocol {
    
    var chatRoomRepository: ChatRoomRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func create(otherUser: User) -> Observable<ChatRoom> {
        return userRepository?.load()
            .flatMap { chatRoomRepository?.create(currentUserID: $0.id, otherUserID: otherUser.id) ?? .empty() } ?? .empty()
    }
}
