//
//  SocialSignupCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class SocialSignupCoordinator: Coordinator, SocialSignupCoordinatorProtocol {

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
        showProfile()
    }
    
    func showProfile() {
        
    }
    
    func showLanguage() {
        
    }
    
    func showCareer() {
        
    }
    
    func finish(success: Bool) {
        delegate?.socialSignupCoordinatorDidFinish(child: self, success: success)
    }
}
