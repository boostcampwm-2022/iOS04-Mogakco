//
//  HashtagRepository.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct HashtagRepository: HashtagRepositoryProtocol {
    
    var localHashtagDataSource: HashtagDataSourceProtocol?

    func loadTagList(kind: KindHashtag) -> Observable<[Hashtag]> {
        return localHashtagDataSource?.loadTagList(kind: kind) ?? .empty()
    }
    
    func loadHashtagByString(kind: KindHashtag, tagTitle: [String]) -> Observable<[Hashtag]> {
        return localHashtagDataSource?.loadHashtagByString(kind: kind, tagTitle: tagTitle) ?? .empty()
    }
}
