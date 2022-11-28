//
//  ProfileTabCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class ProfileTabCoordinator: Coordinator, ProfileTabCoordinatorProtocol {
    
    weak var delegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfile()
    }
    
    func showProfile() {
        let viewModel = ProfileViewModel(
            type: .current,
            coordinator: self,
            userUseCase: UserUseCase(
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                ),
                studyRepository: StudyRepository(
                    studyDataSource: StudyDataSource(provider: Provider.default),
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default)
                )
            )
        )
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showEditProfile() {
        let userRepository = UserRepository(
            localUserDataSource: UserDefaultsUserDataSource(),
            remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
        )
        let viewModel = EditProfiileViewModel(
            type: .edit,
            coordinator: self,
            profileUseCase: ProfileUseCase(userRepository: userRepository),
            editProfileUseCase: EditProfileUseCase(userRepository: userRepository)
        )
        let viewController = EditProfileViewController(viewModel: viewModel)
        navigationController.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChat() {
    }
    
    func showSelectHashtag(kindHashtag: KindHashtag) {
    }
}
