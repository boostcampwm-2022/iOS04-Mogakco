//
//  HashtagSelectProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol HashtagSelectProtocol: AnyObject {
    func selectedHashtag(hashTags: [Hashtag])
}
