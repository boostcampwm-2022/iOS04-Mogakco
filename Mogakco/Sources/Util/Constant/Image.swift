//
//  Image.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

enum Image {
    static let profiles = (1...17).compactMap {
        UIImage(named: "profile\($0)")
    }
    static let profileDefault = UIImage(named: "profile") ?? UIImage()
}
