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
        let studyRepository = StudyRepository(
            studyDataSource: StudyDataSource(provider: Provider.default),
            localUserDataSource: UserDefaultsUserDataSource(),
            remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
            chatRoomDataSource: ChatRoomDataSource(provider: Provider.default)
        )
        
        let viewModel = ProfileViewModel(
            type: type,
            userUseCase: UserUseCase(
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                ),
                studyRepository: studyRepository
            ),
            createChatRoomUseCase: CreateChatRoomUseCase(
                chatRoomRepository: ChatRoomRepository(
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
                    studyDataSource: StudyDataSource(provider: Provider.default)
                ),
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                )
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .editProfile:
                    self?.showEditProfile()
                case .editHashtag(let kind):
                    self?.showHashtag(kind: kind, selectedHashtag: [])
                case .chatRoom(let id):
                    self?.showChatRoom(id: id)
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
    
    // MARK: - 프로필 수정
    
    func showEditProfile() {
        let userRepository = UserRepository(
            localUserDataSource: UserDefaultsUserDataSource(),
            remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
        )
        
        let viewModel = EditProfileViewModel(
            type: .edit,
            profileUseCase: ProfileUseCase(userRepository: userRepository),
            editProfileUseCase: EditProfileUseCase(userRepository: userRepository)
        )
        
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
    
    func showHashtag(kind: KindHashtag, selectedHashtag: [Hashtag]) {
        let viewModel = HashtagEditViewModel(
            hashTagUsecase: HashtagUsecase(
                hashtagRepository: HashtagRepository(
                    localHashtagDataSource: HashtagDataSource()
                )
            ),
            editProfileUseCase: EditProfileUseCase(
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                )
            ),
            selectedHashtag: selectedHashtag
        )
        
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
