//
//  ProfileProps.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

struct ProfileProps {
    let email: String
    let password: String
    let name: String
    let introduce: String
    let profileImage: UIImage
    
    func toLanguageProps(languages: [String]) -> LanguageProps {
        return LanguageProps(
            email: email,
            password: password,
            name: name,
            introduce: introduce,
            profileImage: profileImage,
            languages: languages
        )
    }
}
