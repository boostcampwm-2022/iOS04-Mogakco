//
//  HashtagDataSource.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct HashtagDataSource: HashtagDataSourceProtocol {
 
    func loadTagList(kind: KindHashtag) -> Observable<[Hashtag]> {
        return Observable.create { emitter in
            switch kind {
            case .language: emitter.onNext(loadLanguage())
            case .career: emitter.onNext(loadCareer())
            case .category: emitter.onNext(loadCategory())
            }
            
            return Disposables.create()
        }
    }
    
    private func loadLanguage() -> [Hashtag] {
        return Languages.allCases
    }
    
    private func loadCareer() -> [Hashtag] {
        return Career.allCases
    }
    
    private func loadCategory() -> [Hashtag] {
        return Category.allCases
    }
    
    func loadHashtagByString(kind: KindHashtag, tagTitle: [String]) -> Observable<[Hashtag]> {
        return Observable.create { emitter in
            let tagList: [Hashtag]
            var selectedTags: [Hashtag] = []
            
            switch kind {
            case .language: tagList = loadLanguage()
            case .career: tagList = loadCareer()
            case .category: tagList = loadCategory()
            }
            
            tagList.forEach {
                if tagTitle.contains($0.id) {selectedTags.append($0)}
            }
            
            emitter.onNext(selectedTags)
            return Disposables.create()
        }
    }
}
