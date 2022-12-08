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
    case finish
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
        guard let viewModel = DIContainer.shared.container.resolve(ChatViewModel.self) else { return }
        viewModel.chatRoomID = id

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
    
    // MARK: - 프로필
    
    func showProfile(type: ProfileType) {
        let profile = ProfileCoordinator(type: type, hideTabbar: true, navigationController)
        coordinate(to: profile)
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
