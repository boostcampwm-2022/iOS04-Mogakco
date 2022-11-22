//
//  ChatListViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatListViewModel: ViewModel {
    
    struct Input {
        let selectedChatRoom: Observable<Void>
    }
    
    struct Output {
        let chatRoomList: Observable<[ChatRoom]>
    }
    
    var disposeBag = DisposeBag()
    private weak var coordinator: ChatTabCoordinator?
    private let chatRoomListUseCase: ChatRoomListUseCaseProtocol
 
    init(
        coordinator: ChatTabCoordinator,
        chatRoomListUseCase: ChatRoomListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.chatRoomListUseCase = chatRoomListUseCase
    }
    
    func transform(input: Input) -> Output {

        input
            .selectedChatRoom
            .subscribe(onNext: {
                self.coordinator?.showChatDetail()
            })
            .disposed(by: disposeBag)

        return Output(
            chatRoomList: chatRoomListUseCase.chatRooms()
        )
    }
}
