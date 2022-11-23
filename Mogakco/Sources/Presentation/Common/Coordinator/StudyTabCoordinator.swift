//
//  StudyTabCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class StudyTabCoordinator: Coordinator, StudyTabCoordinatorProtocol {
    
    weak var delegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showStudyList()
    }
    
    func showStudyList() {
        let viewController = StudyListViewController(
            viewModel: StudyListViewModel(
                coordinator: self,
                useCase: StudyListUseCase(
                    repository: StudyRepository(
                        dataSource: StudyDataSource(provider: Provider.default)
                    )
                )
            )
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showStudyDetail() {
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
            retmoteUserDataSource: remoteUserDataSource
        )
        let userUseCase = UserUseCase(userRepository: userRepository)
        
        let viewModel = StudyDetailViewModel(
            studyID: "nN2KGsHG1my3fMo4tjwE", // TODO: StudyID 받아오는 모델로 수정
            coordinator: self,
            studyUsecase: studyUseCase,
            hashtagUseCase: hashtagUseCase,
            userUseCase: userUseCase
        )
        let studyDetailViewController = StudyDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(studyDetailViewController, animated: true)
    }
    
    func showStudyCreate() {
        let viewController = CreateStudyViewController(
            viewModel: CreateStudyViewModel(
                coordinator: self
            )
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showChatDetail() {
        let viewModel = ChatViewModel(coordinator: self)
        let chatViewController = ChatViewController(viewModel: viewModel)
        navigationController.pushViewController(chatViewController, animated: true)
    }
}
