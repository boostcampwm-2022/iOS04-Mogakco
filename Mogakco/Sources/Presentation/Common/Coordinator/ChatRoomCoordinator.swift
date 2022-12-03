//
//  ChatRoomCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum ChatRoomCoordinatorResult {
    case back
}

final class ChatRoomCoordinator: BaseCoordinator<ChatRoomCoordinatorResult> {
    
    private let id: String
    private let finish = PublishSubject<ChatRoomCoordinatorResult>()
    
    init(id: String, _ navigationController: UINavigationController) {
        self.id = id
        super.init(navigationController)
    }
    
    override func start() -> Observable<ChatRoomCoordinatorResult> {
        showChatRoom()
        return finish
            .do(onNext: { [weak self] _ in self?.popTabbar(animated: true) })
    }
    
    // MARK: - 채팅방
    
    func showChatRoom() {
        let studyRepository = StudyRepository(
            studyDataSource: StudyDataSource(provider: Provider.default),
            localUserDataSource: UserDefaultsUserDataSource(),
            remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
            chatRoomDataSource: ChatRoomDataSource(provider: Provider.default)
        )

        let viewModel = ChatViewModel(
            chatRoomID: id,
            chatUseCase: ChatUseCase(
                chatRepository: ChatRepository(chatDataSource: ChatDataSource()),
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                )
            ),
            leaveStudyUseCase: LeaveStudyUseCase(
                studyRepository: studyRepository
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .profile(let type):
                    self?.showProfile(type: type)
                case .study(let id):
                    self?.showStudyDetail(id: id)
                case .back:
                    self?.finish.onNext(.back)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = ChatViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
    
    // MARK: - 스터디 상세
    
    func showStudyDetail(id: String) {
        let study = StudyDetailCoordinator(id: id, navigationController)
        coordinate(to: study)
            .subscribe(onNext: {
                switch $0 {
                case .back: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 프로필
    
    func showProfile(type: ProfileType) {
        let profile = ProfileCoordinator(type: type, hideTabbar: true, navigationController)
        coordinate(to: profile)
            .subscribe(onNext: {
                switch $0 {
                case .back: break
                }
            })
            .disposed(by: disposeBag)
    }
}
