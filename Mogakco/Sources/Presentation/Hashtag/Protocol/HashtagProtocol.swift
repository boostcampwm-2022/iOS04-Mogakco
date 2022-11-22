//
//  Hashtag.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol Hashtag {
    var title: String { get }
    func hashtagTitle() -> String
}
