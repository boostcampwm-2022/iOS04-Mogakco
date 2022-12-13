//
//  CachableImage.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

final class CacheableImage {
    let imageData: Data
    let cacheInfo: CacheInfo
    
    init(imageData: Data, etag: String) {
        self.cacheInfo = CacheInfo(etag: etag, lastRead: Date())
        self.imageData = imageData
    }
}

struct CacheInfo: Codable {
    let etag: String
    let lastRead: Date
}
