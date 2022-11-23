//
//  AdditionalSignupCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

protocol AdditionalSignupCoordinatorProtocol: AnyObject {
    func showCreateProfile(passwordProps: PasswordProps)
    func showLanguage(profileProps: ProfileProps)
    func showCareer(languageProps: LanguageProps)
    func finish(success: Bool)
}
