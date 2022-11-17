//
//  HashtagDataSourceProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol HashtagDataSourceProtocol {
    func loadTagList(kind: KindHashtag) -> [String]
}