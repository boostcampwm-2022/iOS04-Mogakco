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
        let alert: Signal<Alert>
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
    private let alert = PublishSubject<Alert>()

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
            refreshFinished: refreshFinished.asSignal(onErrorSignalWith: .empty()),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    private func bindChats(input: Input) {
        // 채팅 로드
        let newChats = BehaviorSubject<[Chat]>(value: [])
        
        Observable.merge(
            Observable.just(()),
            input.pagination ?? .empty()
        )
            .withUnretained(self)
            .flatMap { $0.0.chatUseCase?.fetch(chatRoomID: $0.0.chatRoomID).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let chats):
                    newChats.onNext(chats)
                case .failure:
                    let alert = Alert(title: "메세지 목록 로드 실패", message: "메세지 목록 로드에 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        newChats
            .withLatestFrom(messages) { $0 + $1 }
            .subscribe(onNext: { [weak self] in
                self?.messages.accept($0)
                self?.sendMessageCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        // 채팅 observe
        
        (chatUseCase?.observe(chatRoomID: chatRoomID).asResult() ?? .empty())
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let chat):
                    if viewModel.isFirst == false {
                        newChats.onNext([chat])
                    } else {
                        viewModel.isFirst = false
                    }
                case .failure:
                    let alert = Alert(title: "메세지 로드 실패", message: "메세지 로드에 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        // 채팅 전송
        let profile = BehaviorSubject<User?>(value: nil)
        
        (chatUseCase?.myProfile().asResult() ?? .empty())
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let user):
                    profile.onNext(user)
                case .failure:
                    let alert = Alert(title: "유저 로드 실패", message: "유저 로드에 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .withLatestFrom(Observable.combineLatest(profile.compactMap { $0 }, input.inputViewText)) { ( $1.0, $1.1 ) }
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
                viewModel.chatUseCase?.send(chat: chat, to: viewModel.chatRoomID).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.sendMessageCompleted.onNext(())
                case .failure:
                    let alert = Alert(title: "메세지 전송 실패", message: "메세지 전송dp 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
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
