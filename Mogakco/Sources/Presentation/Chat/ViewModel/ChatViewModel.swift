//
//  ChatViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatViewModel: ViewModel {
    
    struct Input {
        let backButtonDidTap: Observable<Void>
        let studyInfoButtonDidTap: Observable<Void>
        let selectedSidebar: Observable<IndexPath>
        let sendButtonDidTap: Observable<Void>
        let inputViewText: Observable<String>
    }
    
    struct Output {
        let showChatSidebarView: Observable<Void>
        let selectedSidebar: Observable<ChatSidebarMenu>
        let inputViewText: Observable<String>
        let sendMessage: Observable<Void>
    }
    
    
    private let chatUseCase: ChatUseCaseProtocol
    weak var coordinator: Coordinator?
    private var chatArray: [Chat] = []
    var messages = BehaviorRelay<[Chat]>(value: [])
    var disposeBag = DisposeBag()
    let chatRoomID: String
    
    init(
        coordinator: Coordinator,
        chatUseCase: ChatUseCaseProtocol,
        chatRoomID: String
    ) {
        self.coordinator = coordinator
        self.chatUseCase = chatUseCase
        self.chatRoomID = chatRoomID
    }
    
    func transform(input: Input) -> Output {
        let showChatSidebarView = PublishSubject<Void>()
        let selectedSidebar = PublishSubject<ChatSidebarMenu>()
        let inputViewText = PublishSubject<String>()
        let sendMessage = PublishSubject<Void>()
        
        chatUseCase.fetchAll(chatRoomID: chatRoomID)
            .withLatestFrom(messages) { ($0, $1) }
            .subscribe(onNext: { [weak self] originChats, newChat in
                self?.messages.accept(newChat + [originChats])
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        input.studyInfoButtonDidTap
            .subscribe(onNext: {
                showChatSidebarView.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.selectedSidebar
            .map { ChatSidebarMenu(row: $0.row) }
            .subscribe { row in
                selectedSidebar.on(row)
            }
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .withLatestFrom(Observable.combineLatest(
                chatUseCase.myProfile(),
                input.inputViewText
            )) { ( $1.0, $1.1 ) }
            .subscribe { [weak self] user, message in
                guard let self = self else { return }

                self.chatUseCase
                    .send(
                        chat: Chat(
                            id: UUID().uuidString,
                            userID: user.id,
                            message: message,
                            chatRoomID: self.chatRoomID,
                            date: Date().toInt(dateFormat: "yyyyMMddHHmmss"),
                            readUserIDs: [user.id]
                        ),
                        to: self.chatRoomID
                    )
                    .subscribe {
                        sendMessage.onNext(())
                    }
                    .disposed(by: self.disposeBag)
                
                sendMessage.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            showChatSidebarView: showChatSidebarView,
            selectedSidebar: selectedSidebar,
            inputViewText: inputViewText,
            sendMessage: sendMessage
        )
    }
    
    func userID() -> Observable<User> {
        return chatUseCase.myProfile()
    }
}
