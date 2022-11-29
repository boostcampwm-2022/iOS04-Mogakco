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

        chatUseCase.fetch(chatRoomID: self.chatRoomID)
            .withUnretained(self)
            .subscribe { _, chat in
                self.chatArray.append(chat)
                print("## ", self.chatArray.count)
                self.messages.accept(self.chatArray)
            }
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
                            id: self.chatRoomID,
                            userID: user.id,
                            message: message,
                            chatRoomID: self.chatRoomID,
                            date: Date().toInt(dateFormat: "yyyy-MM-dd HH:mm:ss"),
                            readUserIDs: ["me"]
                        ),
                        to: self.chatRoomID
                    )
                    .subscribe {
                        sendMessage.onNext(())
                    }
                    .disposed(by: self.disposeBag)
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
