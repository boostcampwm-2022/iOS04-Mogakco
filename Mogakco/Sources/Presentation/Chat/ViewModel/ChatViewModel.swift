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
        let pagination: Observable<Void>?
    }
    
    struct Output {
        let showChatSidebarView: Observable<Void>
        let selectedSidebar: Observable<ChatSidebarMenu>
        let inputViewText: Observable<String>
        let sendMessage: Observable<Void>
        let refreshFinished: Observable<Void>
    }
    
    private var isFirst = true
    private let chatUseCase: ChatUseCaseProtocol
    private let leaveStudyUseCase: LeaveStudyUseCaseProtocol
    weak var coordinator: Coordinator?
    private var chatArray: [Chat] = []
    var messages = BehaviorRelay<[Chat]>(value: [])
    var disposeBag = DisposeBag()
    let chatRoomID: String
    
    init(
        coordinator: Coordinator,
        chatUseCase: ChatUseCaseProtocol,
        leaveStudyUseCase: LeaveStudyUseCaseProtocol,
        chatRoomID: String
    ) {
        self.coordinator = coordinator
        self.chatUseCase = chatUseCase
        self.leaveStudyUseCase = leaveStudyUseCase
        self.chatRoomID = chatRoomID
    }
    
    func transform(input: Input) -> Output {
        let showChatSidebarView = PublishSubject<Void>()
        let selectedSidebar = PublishSubject<ChatSidebarMenu>()
        let inputViewText = PublishSubject<String>()
        let sendMessage = PublishSubject<Void>()
        let studyInfoTap = PublishSubject<Void>()
        let exitStudyTap = PublishSubject<Void>()
        let showMemberTap = PublishSubject<Void>()
        let refreshFinished = PublishSubject<Void>()
        
        bindFirebase()
        backButtonDidTap(input: input)
        
        input.pagination?
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.chatUseCase
                    .reload(chatRoomID: self.chatRoomID)
                    .withLatestFrom(self.messages) { ($0, $1) }
                    .subscribe(onNext: { orginalChats, newChat in
                        self.messages.accept([orginalChats] + newChat)
                    })
                    .disposed(by: self.disposeBag)
                
                refreshFinished.onNext(())
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
                switch row {
                case .studyInfo: studyInfoTap.onNext(())
                case .exitStudy: exitStudyTap.onNext(())
                case .showMember: showMemberTap.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        exitStudyTap
            .withUnretained(self)
            .flatMap { $0.0.leaveStudyUseCase.leaveStudy(id: $0.0.chatRoomID) }
            .subscribe {
                selectedSidebar.onNext(.exitStudy)
            } onError: { error in
                print(self.chatRoomID)
                print(error)
            }
            .disposed(by: disposeBag)
        // TODO: 위와 같은 방식으로 studyInfo, showMember추가
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
            sendMessage: sendMessage,
            refreshFinished: refreshFinished
        )
    }
    
    private func bindFirebase() {
        chatUseCase.observe(chatRoomID: chatRoomID)
            .withLatestFrom(messages) { ($0, $1) }
            .subscribe(onNext: { [weak self] originalChats, newChat in
                if self?.isFirst == false {
                    print("self?.isFirst : ", newChat, originalChats)
                    self?.messages.accept(newChat + [originalChats])
                } else {
                    self?.isFirst = false
                }
            })
            .disposed(by: disposeBag)
        
        chatUseCase.fetchAll(chatRoomID: chatRoomID)
            .withLatestFrom(messages) { ($0, $1) }
            .subscribe(onNext: { [weak self] originChats, newChat in
                self?.messages.accept([originChats] + newChat)
            })
            .disposed(by: disposeBag)
    }
    
    private func backButtonDidTap(input: Input) {
        input.backButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
