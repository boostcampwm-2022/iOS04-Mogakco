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
        let viewModel = CreateProfiileViewModel(coordinator: self)
        let viewController = CreateProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showLanguage() {
        let hashtagDataSource = HashtagDataSource()
        let hashtagRepository = HashtagRepository(localHashtagDataSource: hashtagDataSource)
        let hashtagUsecase = HashtagUsecase(hashtagRepository: hashtagRepository)
        let viewModel = HashtagViewModel(coordinator: self, hashTagUsecase: hashtagUsecase)
        let hashtagSelectViewController = HashtagSelectViewController(kind: .language, viewModel: viewModel)
        navigationController.pushViewController(hashtagSelectViewController, animated: true)
    }
    
    func showCareer() {
        let hashtagDataSource = HashtagDataSource()
        let hashtagRepository = HashtagRepository(localHashtagDataSource: hashtagDataSource)
        let hashtagUsecase = HashtagUsecase(hashtagRepository: hashtagRepository)
        let viewModel = HashtagViewModel(coordinator: self, hashTagUsecase: hashtagUsecase)
        let hashtagSelectViewController = HashtagSelectViewController(kind: .career, viewModel: viewModel)
        navigationController.pushViewController(hashtagSelectViewController, animated: true)
    }
    
    func finish(success: Bool) {
        delegate?.additionalSignupCoordinatorDidFinish(child: self, success: success)
    }
}
