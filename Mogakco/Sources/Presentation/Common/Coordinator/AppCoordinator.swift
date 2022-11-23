//
//  AppCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

final class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.backgroundColor = .mogakcoColor.backgroundDefault
        window?.makeKeyAndVisible()
    }

    func start() {
        let studyDataSource = StudyDataSource(provider: Provider.default)
        let studyRepository = StudyRepository(dataSource: studyDataSource)
        let studyUseCase = StudyDetailUseCase(repository: studyRepository)

        let hashtagDataSource = HashtagDataSource()
        let hashtagRepository = HashtagRepository(localHashtagDataSource: hashtagDataSource)
        let hashtagUseCase = HashtagUsecase(hashtagRepository: hashtagRepository)

        let localUserDataSource = UserDefaultsUserDataSource()
        let remoteUserDataSource = RemoteUserDataSource(provider: Provider.default)
        let userRepository = UserRepository(
            localUserDataSource: localUserDataSource,
            remoteUserDataSource: remoteUserDataSource
        )
        let userUseCase = UserUseCase(userRepository: userRepository)

        let viewModel = StudyDetailViewModel(
            studyID: "FEVKKUm24VGBVmmTKICB", // TODO: StudyID 받아오는 모델로 수정
            coordinator: StudyTabCoordinator(navigationController),
            studyUsecase: studyUseCase,
            hashtagUseCase: hashtagUseCase,
            userUseCase: userUseCase
        )
        let studyDetailViewController = StudyDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(studyDetailViewController, animated: true)
//        showAuthFlow()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.delegate = self
        authCoordinator.start()
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController)
        childCoordinators.append(tabCoordinator)
        tabCoordinator.delegate = self
        tabCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {

    func coordinatorDidFinish(child: Coordinator) {
        finish(child)
        switch child {
        case is AuthCoordinator:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        case is TabCoordinator:
            navigationController.viewControllers.removeAll()
            showAuthFlow()
        default:
            break
        }
    }
}
