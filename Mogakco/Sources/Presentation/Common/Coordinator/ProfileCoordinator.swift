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
        viewModel.type.onNext(type)
        
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
        print("DEBUG : email은 \(email)")
        guard let viewModel = DIContainer.shared.container.resolve(SettingViewModel.self) else { return
            print("DIContainer setting 실패")
        }

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .withdraw:
                    print("DEBUG : withdraw! email은 \(email)")
                    self?.showWithdraw(email: email)
                case .logout:
                    print("DEBUG : logout!")
                case .back:
                    self?.popTabbar(animated: true)
                    print("DEBUG : Back!")
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SettingViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
    
    func showWithdraw(email: String) {
        print("DEBUG : showWithdraw email은 \(email)")
        guard let viewModel = DIContainer.shared.container.resolve(WithdrawViewModel.self) else { return
            print("DIContainer 실패")
        }
        
        viewModel.email = email
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .success:
                    print("DEBUG : 회원탈퇴 성공")
                    self?.showLogin()
                case .back:
                    print("DEBUG : 뒤로가기")
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = WithdrawViewController(viewModel: viewModel)
        
        pushTabbar(viewController, animated: true)
    }
    
    func showLogin() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - 프로필 수정
    
    func showEditProfile() {
        guard let viewModel = DIContainer.shared.container.resolve(EditProfileViewModel.self) else { return }
        viewModel.type.onNext(.edit)
        
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
            .subscribe(onNext: {
                switch $0 {
                case .back: break
                }
            })
            .disposed(by: disposeBag)
    }
}
