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
        let refresh: Observable<Void>
        let selectedChatRoom: Observable<ChatRoom>
        let deletedChatRoom: Observable<ChatRoom>
    }
    
    struct Output {
        let chatRooms: Driver<[ChatRoom]>
        let refreshFinished: Signal<Void>
        let isLoading: Driver<Bool>
        let alert: Signal<Alert>
    }
    
    var disposeBag = DisposeBag()
    var chatRoomListUseCase: ChatRoomListUseCaseProtocol?
    private let chatRooms = BehaviorSubject<[ChatRoom]>(value: [])
    static let reload = PublishSubject<Void>()
    private let refreshFinished = PublishSubject<Void>()
    private let isLoading = BehaviorSubject(value: true)
    private let alert = PublishSubject<Alert>()
    let navigation = PublishSubject<ChatListNavigation>()
    
    func transform(input: Input) -> Output {

        Observable.merge(
            Observable.just(()),
            input.viewWillAppear.skip(1),
            input.refresh,
            ChatListViewModel.reload
        )
            .withUnretained(self)
            .flatMap { viewModel, _ in viewModel.chatRoomListUseCase?.chatRooms().asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                viewModel.refreshFinished.onNext(())
                switch result {
                case let .success(chatRooms):
                    viewModel.chatRooms.onNext(chatRooms)
                case .failure:
                    viewModel.chatRooms.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.selectedChatRoom
            .map { ChatListNavigation.chatRoom(id: $0.id) }
            .bind(to: navigation)
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
                    ChatListViewModel.reload.onNext(())
                case .failure:
                    let alert = Alert(title: "채팅방 나가기 오류", message: "채팅방 삭제 오류가 발생했어요! 다시 시도해주세요.", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        chatRooms
            .skip(1)
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        return Output(
            chatRooms: chatRooms.asDriver(onErrorJustReturn: []),
            refreshFinished: refreshFinished.asSignal(onErrorJustReturn: ()),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
