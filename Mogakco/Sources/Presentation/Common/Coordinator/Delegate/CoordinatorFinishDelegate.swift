//
//  CoordinatorFinishDelegate.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
