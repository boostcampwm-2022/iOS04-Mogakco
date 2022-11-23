//
//  AdditionalSignupCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class AdditionalSignupCoordinator: Coordinator, AdditionalSignupCoordinatorProtocol {

    weak var delegate: AuthCoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var name: String?
    var introduce: String?
    var profile: UIImage?
    var language: String?
    var career: String?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCreateProfile()
    }
    
    func showCreateProfile() {
        let userRepository = UserRepository(
            localUserDataSource: UserDefaultsUserDataSource(),
            remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
        )
        let viewModel = EditProfiileViewModel(
            type: .create,
            coordinator: self,
            profileUseCase: ProfileUseCase(userRepository: userRepository),
            editProfileUseCase: EditProfileUseCase(userRepository: userRepository)
        )
        let viewController = EditProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showLanguage() {
        let hashtagDataSource = HashtagDataSource()
        let hashtagRepository = HashtagRepository(localHashtagDataSource: hashtagDataSource)
        let hashtagUseCase = HashtagUsecase(hashtagRepository: hashtagRepository)
        let viewModel = HashtagSelectedViewModel(
            coordinator: self,
            hashTagUsecase: hashtagUseCase
        )
        let hashtagSelectViewController = HashtagSelectViewController(
            kind: .language,
            viewModel: viewModel
        )
        navigationController.pushViewController(hashtagSelectViewController, animated: true)
    }
    
    func showCareer() {
        let hashtagDataSource = HashtagDataSource()
        let authService = FBAuthService(provider: Provider.default)
        let userDefaultDataSource = UserDefaultsUserDataSource()
        let remoteUserDataSouce = RemoteUserDataSource(provider: Provider.default)
        let hashtagRepository = HashtagRepository(localHashtagDataSource: hashtagDataSource)
        let authRepository = AuthRepository(authService: authService)
        let userRepository = UserRepository(
            localUserDataSource: userDefaultDataSource,
            remoteUserDataSource: remoteUserDataSouce
        )
        let hashtagUseCase = HashtagUsecase(hashtagRepository: hashtagRepository)
        let signupUseCase = SignupUseCase(
            authRepository: authRepository,
            userRepository: userRepository
        )
        let viewModel = HashtagSelectedViewModel(
            coordinator: self,
            hashTagUsecase: hashtagUseCase,
            signUpUseCase: signupUseCase
        )
        let hashtagSelectViewController = HashtagSelectViewController(
            kind: .career,
            viewModel: viewModel
        )
        navigationController.pushViewController(hashtagSelectViewController, animated: true)
    }
    
    func finish(success: Bool) {
        delegate?.additionalSignupCoordinatorDidFinish(child: self, success: success)
    }
}
