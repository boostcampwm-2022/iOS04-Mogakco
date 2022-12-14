//
//  LanguageProps.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

struct LanguageProps {
    let email: String
    let password: String
    let name: String
    let introduce: String
    let profileImage: UIImage
    let languages: [String]
    
    func toSignupProps(careers: [String]) -> SignupProps {
        return SignupProps(
            email: email,
            password: password,
            name: name,
            introduce: introduce,
            profileImage: profileImage,
            languages: languages,
            careers: careers
        )
    }
}
