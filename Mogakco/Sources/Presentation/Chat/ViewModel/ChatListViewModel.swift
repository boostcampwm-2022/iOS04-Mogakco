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
        let alert: Signal<String>
    }
    
    var disposeBag = DisposeBag()
    var chatRoomListUseCase: ChatRoomListUseCaseProtocol?
    private let chatRooms = BehaviorSubject<[ChatRoom]>(value: [])
    private let reload = PublishSubject<Void>()
    private let alert = PublishSubject<String>()
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
            .flatMap { viewModel, _ in viewModel.chatRoomListUseCase?.chatRooms().asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case let .success(chatRooms):
                    viewModel.chatRooms.onNext(chatRooms)
                case .failure:
                    viewModel.chatRooms.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.deletedChatRoom
            .withUnretained(self)
            .flatMap { viewModel, chatRoom in
                viewModel.chatRoomListUseCase?.leave(chatRoom: chatRoom).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.reload.onNext(())
                case .failure:
                    viewModel.alert.onNext("채팅방 삭제 오류가 발생했어요! 다시 시도해주세요.")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            chatRooms: chatRooms.asDriver(onErrorJustReturn: []),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
