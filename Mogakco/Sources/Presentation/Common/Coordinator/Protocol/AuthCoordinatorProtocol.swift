//
//  AuthCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol AuthCoordinatorProtocol: AnyObject {
    func showLogin()
    func showRequiredSignup()
    func showAdditionalSignup(email: String?, password: String?)
    func finish()
}
