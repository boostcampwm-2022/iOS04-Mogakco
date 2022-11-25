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
    
    func showStudyDetail(id: String) {
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
        let userUseCase = UserUseCase(userRepository: userRepository, studyRepository: studyRepository)
        
        let viewModel = StudyDetailViewModel(
            studyID: id,
            coordinator: self,
            studyUsecase: studyUseCase,
            hashtagUseCase: hashtagUseCase,
            userUseCase: userUseCase
        )
        let viewController = StudyDetailViewController(viewModel: viewModel)
        navigationController.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showStudyCreate() {
        let viewController = CreateStudyViewController(
            viewModel: CreateStudyViewModel(
                coordinator: self,
                useCase: CreateStudyUseCase(
                    studyRepository: StudyRepository(
                        dataSource: StudyDataSource(provider: Provider.default)
                    ),
                    userRepository: UserRepository(
                        localUserDataSource: UserDefaultsUserDataSource(),
                        remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                    )
                )
            )
        )
        navigationController.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChatDetail() {
        let viewModel = ChatViewModel(coordinator: self)
        let chatViewController = ChatViewController(viewModel: viewModel)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showCategorySelect(delegate: HashtagSelectProtocol?) {
        let viewModel = HashtagFilterViewModel(
            coordinator: self,
            hashTagUsecase: HashtagUsecase(
                hashtagRepository: HashtagRepository(
                    localHashtagDataSource: HashtagDataSource()
                )
            ),
            selectedHashtag: []
        )
        viewModel.delegate = delegate
        let viewController = HashtagSelectViewController(
            kind: .category,
            viewModel: viewModel
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showLanguageSelect(delegate: HashtagSelectProtocol?) {
        let viewModel = HashtagFilterViewModel(
            coordinator: self,
            hashTagUsecase: HashtagUsecase(
                hashtagRepository: HashtagRepository(
                    localHashtagDataSource: HashtagDataSource()
                )
            ),
            selectedHashtag: []
        )
        viewModel.delegate = delegate
        let viewController = HashtagSelectViewController(
            kind: .language,
            viewModel: viewModel
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToPrevScreen() {
        self.pop(animated: true)
    }
}
