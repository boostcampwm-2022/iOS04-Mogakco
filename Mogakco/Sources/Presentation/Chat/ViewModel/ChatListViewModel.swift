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

enum ChatListNavigation {
    case chatRoom(id: String)
}

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
    var chatRoomListUseCase: ChatRoomListUseCaseProtocol?
    private let chatRooms = BehaviorSubject<[ChatRoom]>(value: [])
    private let reload = PublishSubject<Void>()
    let navigation = PublishSubject<ChatListNavigation>()
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.reload.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.selectedChatRoom
            .map { ChatListNavigation.chatRoom(id: $0.id) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        reload
            .withUnretained(self)
            .flatMap { viewModel, _ in viewModel.chatRoomListUseCase?.chatRooms() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, chatRooms in
                viewModel.chatRooms.onNext(chatRooms)
            }, onError: {
                print("@@@@@@ ERORR \($0.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        input.deletedChatRoom
            .withUnretained(self)
            .compactMap { viewModel, chatRoom in
                viewModel.chatRoomListUseCase?.leave(chatRoom: chatRoom) ?? .empty()
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
