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
                    chatDataSource: ChatDataSource(provider: Provider.default)
                )
            )
        )
        let viewController = ChatListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showChatDetail() {
        let viewController = ChatViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
