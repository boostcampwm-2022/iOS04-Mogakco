//
//  ProfileCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum ProfileCoordinatorResult {
    case finish
    case back
}

final class ProfileCoordinator: BaseCoordinator<ProfileCoordinatorResult> {
    
    private let type: ProfileType
    private let hideTabbar: Bool
    private let finish = PublishSubject<ProfileCoordinatorResult>()
    
    init(
        type: ProfileType,
        hideTabbar: Bool,
        _ navigationController: UINavigationController
    ) {
        self.type = type
        self.hideTabbar = hideTabbar
        super.init(navigationController)
    }
    
    override func start() -> Observable<ProfileCoordinatorResult> {
        showProfile()
        return finish
            .do(onNext: { [weak self] _ in
                if self?.hideTabbar ?? false {
                    self?.popTabbar(animated: true)
                } else {
                    self?.pop(animated: true)
                }
            })
    }
    
    // MARK: - 프로필
    
    func showProfile() {
        guard let viewModel = DIContainer.shared.container.resolve(ProfileViewModel.self) else { return }
        viewModel.type = type
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .editProfile:
                    self?.showEditProfile()
                case let .editHashtag(kind: kind, selectedHashtags: selectedHashtags):
                    self?.showHashtag(kind: kind, selectedHashtags: selectedHashtags)
                case let .chatRoom(id):
                    self?.showChatRoom(id: id)
                case let .setting(email):
                    self?.setting(email: email)
                case .back:
                    self?.finish.onNext(.back)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = ProfileViewController(viewModel: viewModel)
        
        if hideTabbar {
            pushTabbar(viewController, animated: true)
        } else {
            push(viewController, animated: true)
        }
    }
    
    // MARK: - 설정화면
    
    func setting(email: String) {
        guard let viewModel = DIContainer.shared.container.resolve(SettingViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .withdraw:
                    self?.showWithdraw(email: email)
                case .logout:
                    break
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SettingViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
    
    func showWithdraw(email: String) {
        guard let viewModel = DIContainer.shared.container.resolve(WithdrawViewModel.self) else { return }
        viewModel.email = email
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .success:
                    self?.finish.onNext(.finish)
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = WithdrawViewController(viewModel: viewModel)
        
        pushTabbar(viewController, animated: true)
    }
    
    // MARK: - 프로필 수정
    
    func showEditProfile() {
        guard let viewModel = DIContainer.shared.container.resolve(EditProfileViewModel.self) else { return }
        viewModel.type = .edit
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish, .back:
                    self?.popTabbar(animated: true)
                case .next:
                    fatalError("do not navigate to next screen")
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = EditProfileViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
    
    // MARK: - 프로필 해시태그 수정
    
    func showHashtag(kind: KindHashtag, selectedHashtags: [Hashtag]) {
        guard let viewModel = DIContainer.shared.container.resolve(HashtagEditViewModel.self) else { return }
        viewModel.selectedHashtags = selectedHashtags
        
        viewModel.finish
            .subscribe(onNext: { [weak self] in
                self?.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
        
        let viewController = HashtagSelectViewController(kind: kind, viewModel: viewModel)
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
}
