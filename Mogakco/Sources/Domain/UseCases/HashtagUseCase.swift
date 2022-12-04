//
//  HashtagUseCase.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct HashtagUseCase: HashtagUseCaseProtocol {
    
    var hashtagRepository: HashtagRepositoryProtocol?
    
    func loadTagList(kind: KindHashtag) -> Observable<[Hashtag]> {
        return hashtagRepository?.loadTagList(kind: kind) ?? .empty()
    }
    
    func loadHashtagByString(kind: KindHashtag, tagTitle: [String]) -> Observable<[Hashtag]> {
        return hashtagRepository?.loadHashtagByString(kind: kind, tagTitle: tagTitle) ?? .empty()
    }
}
