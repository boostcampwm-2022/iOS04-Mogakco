//
//  StudyDetailCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum StudyDetailCoordinatorResult {
    case finish
    case back
}

final class StudyDetailCoordinator: BaseCoordinator<StudyDetailCoordinatorResult> {
    
    private let id: String
    private let finish = PublishSubject<StudyDetailCoordinatorResult>()
    
    init(id: String, _ navigationController: UINavigationController) {
        self.id = id
        super.init(navigationController)
    }
   
    override func start() -> Observable<StudyDetailCoordinatorResult> {
        showStudyDetail()
        return finish
            .do(onNext: { [weak self] _ in self?.popTabbar(animated: true) })
    }
    
    // MARK: - 스터디 상세
    
    func showStudyDetail() {
        guard let viewModel = DIContainer.shared.container.resolve(StudyDetailViewModel.self) else { return }
        viewModel.studyID = id

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .chatRoom(let id):
                    self?.showChatRoom(id: id)
                case .profile(let type):
                    self?.showProfile(type: type)
                case .back:
                    self?.finish.onNext(.back)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = StudyDetailViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
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
    
    // MARK: - 사용자 프로필
    
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
