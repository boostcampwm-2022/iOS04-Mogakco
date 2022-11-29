//
//  ChatTabCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class ChatTabCoordinator: Coordinator, ChatTabCoordinatorProtocol {
    
    weak var delegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showChatList()
    }
    
    func showChatList() {
        let viewModel = ChatListViewModel(
            coordinator: self,
            chatRoomListUseCase: ChatRoomListUseCase(
                chatRoomRepository: ChatRoomRepository(
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                ), userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default))
            )
        )
        let viewController = ChatListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showChatDetail(chatRoomID: String) {
        let localUserDataSource = UserDefaultsUserDataSource()
        let remoteUserDataSource = RemoteUserDataSource(provider: Provider.default)
        let chatDataSource = ChatDataSource()
        let studyDataSource = StudyDataSource(provider: Provider.default)
        let chatRoomDataSource = ChatRoomDataSource(provider: Provider.default)
        
        let chatRepository = ChatRepository(chatDataSource: chatDataSource)
        let userRepository = UserRepository(
            localUserDataSource: localUserDataSource,
            remoteUserDataSource: remoteUserDataSource
        )
        let studyRepository = StudyRepository(
            studyDataSource: studyDataSource,
            localUserDataSource: localUserDataSource,
            remoteUserDataSource: remoteUserDataSource,
            chatRoomDataSource: chatRoomDataSource
        )
        let chatRoomRespository = ChatRoomRepository(
            chatRoomDataSource: chatRoomDataSource,
            remoteUserDataSource: remoteUserDataSource
        )
        
        let chatUseCase = ChatUseCase(
            chatRepository: chatRepository,
            userRepository: userRepository
        )
        let leaveStudyUseCase = LeaveStudyUseCase(
            studyRepository: studyRepository
        )
        
        let viewModel = ChatViewModel(
            coordinator: self,
            chatUseCase: chatUseCase,
            leaveStudyUseCase: leaveStudyUseCase,
            chatRoomID: chatRoomID
        )
        let chatViewController = ChatViewController(viewModel: viewModel)
        navigationController.tabBarController?.navigationController?.pushViewController(
            chatViewController,
            animated: true
        )
    }
}
