//
//  SocialSignupCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

protocol SocialSignupCoordinatorProtocol {
    var name: String? { get set }
    var introduce: String? { get set }
    var profile: UIImage? { get set }
    var language: String? { get set }
    var career: String? { get set }
    
    func showProfile()
    func showLanguage()
    func showCareer()
    func finish(success: Bool)
}
