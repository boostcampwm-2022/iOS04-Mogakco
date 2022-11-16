//
//  AuthCoordinatorFinishDelegate.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol AuthCoordinatorFinishDelegate: AnyObject {
    func autoLoginCoordinatorDidFinish(child: Coordinator, success: Bool)
    func signupCoordinatorDidFinish(child: Coordinator, email: String?, password: String?)
    func socialSignupCoordinatorDidFinish(child: Coordinator, success: Bool)
}
