//
//  PasswordProps.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

struct PasswordProps {
    let email: String
    let password: String
    
    func toProfileProps(
        name: String,
        introduce: String,
        profileImage: UIImage
    ) -> ProfileProps {
        
        return ProfileProps(
            email: email,
            password: password,
            name: name,
            introduce: introduce,
            profileImage: profileImage
        )
    }
}
