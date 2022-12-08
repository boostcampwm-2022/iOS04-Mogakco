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

enum ChatRoomNavigation {
    case profile(type: ProfileType)
    case study(id: String)
    case back
}

final class ChatViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let viewWillDisappear: Observable<Void>
        let willEnterForeground: Observable<Void>
        let didEnterBackground: Observable<Void>
        let backButtonDidTap: Observable<Void>
        let studyInfoButtonDidTap: Observable<Void>
        let selectedSidebar: Observable<IndexPath>
        let sendButtonDidTap: Observable<Void>
        let inputViewText: Observable<String>
        let pagination: Observable<Void>?
        let selectedUser: Observable<User>
    }
    
    struct Output {
        let messages: Driver<[Chat]>
        let chatSidebarMenus: Driver<[ChatSidebarMenu]>
        let showChatSidebarView: Signal<Void>
        let selectedSidebar: Signal<ChatSidebarMenu>
        let inputViewText: Driver<String>
        let sendMessageCompleted: Driver<Void>
        let refreshFinished: Signal<Void>
    }
    
    private var isFirst = true
    var chatRoomID: String = ""
    var chatUseCase: ChatUseCaseProtocol?
    var leaveStudyUseCase: LeaveStudyUseCaseProtocol?
    var subscribePushNotificationUseCase: SubscribePushNotificationUseCaseProtocol?
    var unsubscribePushNotificationUseCase: UnsubscribePushNotificationUseCaseProtocol?
    private var chatArray: [Chat] = []
    let messages = BehaviorRelay<[Chat]>(value: [])
    let navigation = PublishSubject<ChatRoomNavigation>()
    var disposeBag = DisposeBag()
    
    private let selectedSidebar = PublishSubject<ChatSidebarMenu>()
    private let inputViewText = PublishSubject<String>()
    private let sendMessageCompleted = PublishSubject<Void>()
    private let studyInfoTap = PublishSubject<Void>()
    private let exitStudyTap = PublishSubject<Void>()
    private let showMemberTap = PublishSubject<Void>()
    private let refreshFinished = PublishSubject<Void>()

    func transform(input: Input) -> Output {
        bindChats(input: input)
        bindSideBar(input: input)
		bindPushNotification(input: input)
        bindScene(input: input)

        return Output(
            messages: messages.asDriver(onErrorJustReturn: []),
            chatSidebarMenus: Driver<[ChatSidebarMenu]>.just(ChatSidebarMenu.allCases),
            showChatSidebarView: input.studyInfoButtonDidTap.asObservable().asSignal(onErrorSignalWith: .empty()),
            selectedSidebar: selectedSidebar.asSignal(onErrorSignalWith: .empty()),
            inputViewText: inputViewText.asDriver(onErrorJustReturn: ""),
            sendMessageCompleted: sendMessageCompleted.asDriver(onErrorJustReturn: ()),
            refreshFinished: refreshFinished.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    private func bindChats(input: Input) {
        // 채팅 로드
        
        Observable.merge(
            Observable.just(()),
            input.pagination ?? .empty()
        )
            .withUnretained(self)
            .flatMap { $0.0.chatUseCase?.fetch(chatRoomID: $0.0.chatRoomID) ?? .empty() }
            .withLatestFrom(messages) { ($0, $1) }
            .subscribe(onNext: { [weak self] newChat, originalChat in
                self?.messages.accept(newChat + originalChat)
                self?.sendMessageCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        // 채팅 observe
        
        chatUseCase?.observe(chatRoomID: chatRoomID)
            .withLatestFrom(messages) { ($0, $1) }
            .subscribe(onNext: { [weak self] newChat, originalChats in
                if self?.isFirst == false {
                    self?.messages.accept(originalChats + [newChat])
                } else {
                    self?.isFirst = false
                }
            })
            .disposed(by: disposeBag)
        
        // 채팅 전송
        
        input.sendButtonDidTap
            .withLatestFrom(Observable.combineLatest(
                chatUseCase?.myProfile() ?? .empty(),
                input.inputViewText
            )) { ( $1.0, $1.1 ) }
            .map { user, message -> Chat in
                return Chat(
                    id: UUID().uuidString,
                    userID: user.id,
                    message: message,
                    chatRoomID: self.chatRoomID,
                    date: Date().toInt(dateFormat: Format.chatDateFormat),
                    readUserIDs: [user.id]
                )
            }
            .withUnretained(self)
            .flatMap { viewModel, chat in
                viewModel.chatUseCase?.send(chat: chat, to: viewModel.chatRoomID) ?? .empty()
            }
            .subscribe(onNext: { [weak self] in
                self?.sendMessageCompleted.onNext(())
            }, onError: {
                print("메세지 전송 실패 \($0)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSideBar(input: Input) {
        input.selectedSidebar
            .map { ChatSidebarMenu(row: $0.row) }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, row in
                switch row {
                case .studyInfo: viewModel.studyInfoTap.onNext(())
                case .exitStudy: viewModel.exitStudyTap.onNext(())
                case .showMember: viewModel.showMemberTap.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        studyInfoTap
            .subscribe(onNext: { [weak self] in
                self?.selectedSidebar.onNext(.studyInfo)
            })
            .disposed(by: disposeBag)
        
        exitStudyTap
            .withUnretained(self)
            .flatMap { $0.0.leaveStudyUseCase?.leaveStudy(id: $0.0.chatRoomID) ?? .empty() }
            .subscribe(onNext: { [weak self] in
                self?.selectedSidebar.onNext(.exitStudy)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        showMemberTap
            .subscribe(onNext: { [weak self] in
                self?.selectedSidebar.onNext(.showMember)
            })
            .disposed(by: disposeBag)
    }

 	private func bindPushNotification(input: Input) {
        // 채팅방 들어올 시 -> 푸쉬 알림 구독 해제
        Observable.merge(
            input.viewWillAppear,
            input.willEnterForeground
        )
        .withUnretained(self)
        .flatMap { $0.0.unsubscribePushNotificationUseCase?.excute(topic: $0.0.chatRoomID) ?? .empty() }
        .subscribe(onNext: { _ in
        })
        .disposed(by: disposeBag)
        
        // 채팅방 나갈 시 -> 푸쉬 알림 구독
        Observable.merge(
            input.viewWillDisappear,
            input.didEnterBackground
        )
        .withUnretained(self)
        .flatMap { $0.0.subscribePushNotificationUseCase?.excute(topic: $0.0.chatRoomID) ?? .empty() }
        .subscribe(onNext: { _ in
        })
        .disposed(by: disposeBag)
    }

    
    private func bindScene(input: Input) {
        input.backButtonDidTap
            .map { ChatRoomNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.selectedUser
            .map { .profile(type: .other($0)) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
