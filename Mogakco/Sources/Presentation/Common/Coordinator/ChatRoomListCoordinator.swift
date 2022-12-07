//
//  ChatRoomListCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum ChatRoomListCoordinatorResult {
    case finish
}

final class ChatRoomListCoordinator: BaseCoordinator<ChatRoomListCoordinatorResult> {
    
    private let finish = PublishSubject<ChatRoomListCoordinatorResult>()
    
    override func start() -> Observable<ChatRoomListCoordinatorResult> {
        showChatRoomList()
        return Observable.never()
    }
    
    // MARK: - 채팅방 목록
    
    func showChatRoomList() {
        guard let viewModel = DIContainer.shared.container.resolve(ChatListViewModel.self) else { return }
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .chatRoom(let id):
                    self?.showChatRoom(id: id)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = ChatListViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 채팅방
    
    func showChatRoom(id: String) {
        let chatRoom = ChatRoomCoordinator(id: id, navigationController)
        coordinate(to: chatRoom)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .back:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
