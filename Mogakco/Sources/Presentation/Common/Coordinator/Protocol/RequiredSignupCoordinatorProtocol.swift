//
//  RequiredSignupCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol RequiredSignupCoordinatorProtocol: AnyObject {
    var email: String? { get set }
    var password: String? { get set }
    
    func showEmail()
    func showPassword()
    func finish()
}
