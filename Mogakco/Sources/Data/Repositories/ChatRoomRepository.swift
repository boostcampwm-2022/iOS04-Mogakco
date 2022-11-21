//
//  ChatRoomRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ChatRoomRepository: ChatRoomRepositoryProtocol {
    private let chatRoomDataSource: ChatRoomDataSourceProtocol
    private let chatDataSource: ChatDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        chatRoomDataSource: ChatRoomDataSourceProtocol,
        chatDataSource: ChatDataSourceProtocol
    ) {
        self.chatRoomDataSource = chatRoomDataSource
        self.chatDataSource = chatDataSource
    }

    func list() -> Observable<[ChatRoom]> {
        return chatRoomDataSource.list()
            .map { $0.documents.map { $0.toDomain() } } // TODO: Lastest Chat
    }
}
