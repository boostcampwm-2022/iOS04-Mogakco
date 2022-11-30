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
        let viewWillAppear: Observable<Void>
        let selectedChatRoom: Observable<ChatRoom>
        let deletedChatRoom: Observable<ChatRoom>
    }
    
    struct Output {
        let chatRooms: Driver<[ChatRoom]>
    }
    
    var disposeBag = DisposeBag()
    private weak var coordinator: ChatTabCoordinatorProtocol?
    private let chatRoomListUseCase: ChatRoomListUseCaseProtocol
    private let chatRooms = BehaviorSubject<[ChatRoom]>(value: [])
    private let reload = PublishSubject<Void>()
    init(
        coordinator: ChatTabCoordinatorProtocol,
        chatRoomListUseCase: ChatRoomListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.chatRoomListUseCase = chatRoomListUseCase
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.reload.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.selectedChatRoom
            .withUnretained(self)
            .subscribe(onNext: { viewModel, chatRoom in
                viewModel.coordinator?.showChatDetail(chatRoomID: chatRoom.id)
            })
            .disposed(by: disposeBag)
        
        reload
            .withUnretained(self)
            .flatMap { viewModel, _ in viewModel.chatRoomListUseCase.chatRooms() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, chatRooms in
                viewModel.chatRooms.onNext(chatRooms)
            }, onError: {
                print("@@@@@@ ERORR \($0.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        input.deletedChatRoom
            .withUnretained(self)
            .flatMap { viewModel, chatRoom in
                viewModel.chatRoomListUseCase.leave(chatRoom: chatRoom)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                print("@@  LEAVE SUCCESS")
                viewModel.reload.onNext(())
            }, onError: { _ in
                print("@@  LEAVE ERROR")
            })
            .disposed(by: disposeBag)
        
        return Output(
            chatRooms: chatRooms.asDriver(onErrorJustReturn: [])
        )
    }
}
