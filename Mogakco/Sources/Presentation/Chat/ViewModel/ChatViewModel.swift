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
        let selectedSidebar: Observable<ChatSidebarMenu>
        let sendButtonDidTap: Observable<Void>
        let inputViewText: Observable<String>
        let pagination: Observable<Void>?
        let selectedUser: Observable<User>
        let chatMenuSelected: Observable<ChatMenu>
    }
    
    struct Output {
        let messages: Driver<[Chat]>
        let chatSidebarMenus: Driver<[ChatSidebarMenu]>
        let showChatSidebarView: Signal<Void>
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
    
    private let inputViewText = PublishSubject<String>()
    private let sendMessageCompleted = PublishSubject<Void>()
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
            inputViewText: inputViewText.asDriver(onErrorJustReturn: ""),
            sendMessageCompleted: sendMessageCompleted.asDriver(onErrorJustReturn: ()),
            refreshFinished: refreshFinished.asSignal(onErrorSignalWith: .empty()),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    private func bindChats(input: Input) {
        // 채팅 로드
        let newChats = BehaviorSubject<[Chat]>(value: [])
        // 채팅 observe
        let newChat = PublishSubject<Chat>()
        // 유저 정보 로드
        let profile = BehaviorSubject<User?>(value: nil)
        
        Observable.merge(
            Observable.just(()),
            input.pagination ?? .empty()
        )
            .withUnretained(self)
            .flatMap { $0.0.chatUseCase?.fetch(chatRoomID: $0.0.chatRoomID).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { _, result in
                switch result {
                case .success(let chats):
                    newChats.onNext(chats)
                case .failure:
                    newChats.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            newChats,
            profile.compactMap { $0 }
        )
        .flatMap { [weak self] chats, user in
            let observe: [Observable<Void>] = chats.map {
                self?.chatUseCase?.read(chat: $0, userID: user.id) ?? .empty()
            }
            return Observable
                .combineLatest(observe)
                .map { _ in }
        }
        .subscribe(onNext: { _ in })
        .disposed(by: disposeBag)
        
        input.pagination?
            .subscribe(refreshFinished)
            .disposed(by: disposeBag)
        
        newChats
            .withLatestFrom(messages) { $0 + $1 }
            .subscribe(onNext: { [weak self] in
                self?.messages.accept($0)
            })
            .disposed(by: disposeBag)
        
        newChat
            .withLatestFrom(messages) { $1 + [$0] }
            .subscribe(onNext: { [weak self] in
                self?.messages.accept($0)
                self?.sendMessageCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        (chatUseCase?.observe(chatRoomID: chatRoomID).asResult() ?? .empty())
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let chat):
                    let chatID = try? newChats.value().last?.id
                    if viewModel.isFirst == false && chat.id != chatID {
                        newChat.onNext(chat)
                    } else {
                        viewModel.isFirst = false
                    }
                case .failure:
                    let alert = Alert(title: "메세지 로드 실패", message: "메세지 로드에 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
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
        
        // 새로운 채팅 읽음 처리
        newChat
            .withLatestFrom(profile.compactMap { $0 }) { ($0, $1) }
            .flatMap { [weak self] chat, user in
                self?.chatUseCase?.read(chat: chat, userID: user.id) ?? .empty()
            }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .withLatestFrom(Observable.combineLatest(
                profile.compactMap { $0 },
                input.inputViewText)) { ( $1.0, $1.1 ) }
            .map { user, message -> Chat in
                return Chat(
                    id: UUID().uuidString,
                    userID: user.id,
                    message: message,
                    chatRoomID: self.chatRoomID,
                    date: Date().toInt(dateFormat: Format.chatDateFormat),
                    readUserIDs: [user.id],
                    user: user
                )
            }
            .withUnretained(self)
            .flatMap { viewModel, chat in
                viewModel.chatUseCase?.send(chat: chat).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.sendMessageCompleted.onNext(())
                case .failure:
                    let alert = Alert(title: "메세지 전송 실패", message: "메세지 전송에 실패했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSideBar(input: Input) {

        input.selectedSidebar
            .filter { $0 == .studyInfo }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.navigation.onNext(.study(id: viewModel.chatRoomID))
            })
            .disposed(by: disposeBag)
        
        let leaveStudyAlertObserver = PublishSubject<Bool>()
        
        input.selectedSidebar
            .filter { $0 == .exitStudy }
            .map { _ in
                Alert(title: "채팅방 나가기", message: "채팅방을 나가시겠습니까?", observer: leaveStudyAlertObserver.asObserver())
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, alert in
                viewModel.alert.onNext(alert)
            })
            .disposed(by: disposeBag)
        
        leaveStudyAlertObserver
            .filter { $0 }
            .withUnretained(self)
            .flatMap { $0.0.leaveStudyUseCase?.leaveStudy(id: $0.0.chatRoomID).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.navigation.onNext(.back)
                case .failure(let error):
                    
                    let alert = Alert(title: "채팅방 나가기 오류", message: "채팅방 나가기 오류가 발생했어요.", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        // input.selectedSidebar
        //     .filter { $0 == .showMember }
        //     .subscribe(onNext: { _ in
        //         // TODO: 유저 정보 화면 이동
        //     })
        //     .disposed(by: disposeBag)
    }

 	private func bindPushNotification(input: Input) {
        // 채팅방 들어올 시 -> 푸쉬 알림 구독 해제
        Observable.merge(
            input.viewWillAppear,
            input.willEnterForeground
        )
        .withUnretained(self)
        .flatMap { $0.0.unsubscribePushNotificationUseCase?.excute(topic: $0.0.chatRoomID) ?? .empty() }
        .subscribe(onNext: { [weak self] _ in
            self?.isFirst = true
        })
        .disposed(by: disposeBag)
        
        // 채팅방 나갈 시 -> 푸쉬 알림 구독
        Observable.merge(
            input.viewWillDisappear,
            input.didEnterBackground
        )
        .withUnretained(self)
        .flatMap { $0.0.subscribePushNotificationUseCase?.excute(topic: $0.0.chatRoomID) ?? .empty() }
        .subscribe(onNext: { [weak self] _ in
            print("DEBUG : OBSERVE OUT")
            self?.isFirst = true
            self?.chatUseCase?.stopObserving()
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
        
        input.chatMenuSelected
            .withUnretained(self)
            .subscribe(onNext: { viewModel, menu in
                switch menu {
                case .report:
                    let alert = Alert(title: "채팅 신고", message: "채팅을 신고하시겠습니까?", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
}
