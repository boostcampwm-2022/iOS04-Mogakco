//
//  HashtagRepository.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct HashtagRepository: HashtagRepositoryProtocol {
    
    let localHashtagDataSource: HashtagDataSourceProtocol
    
    func loadTagList(kind: KindHashtag) -> [String] {
        let tagList = localHashtagDataSource.loadTagList(kind: kind)
        return tagList
    }
}
