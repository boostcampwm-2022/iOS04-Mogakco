//
//  HashtagUsecase.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct HashtagUsecase: HashtagUseCaseProtocol {
    
    let hashtagRepository: HashtagRepositoryProtocol
    
    init(hashtagRepository: HashtagRepositoryProtocol) {
        self.hashtagRepository = hashtagRepository
    }
    
    func loadTagList(kind: KindHashtag) -> Observable<[Hashtag]> {
        return hashtagRepository.loadTagList(kind: kind)
    }
}
