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

    }
    
    func showStudyDetail() {
        
    }
}
