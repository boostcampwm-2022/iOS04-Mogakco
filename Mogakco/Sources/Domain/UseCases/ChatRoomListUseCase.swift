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
    private let disposeBag = DisposeBag()
    
    init(chatRoomRepository: ChatRoomRepositoryProtocol) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func list() -> Observable<[ChatRoom]> {
        return chatRoomRepository.list()
    }
}
