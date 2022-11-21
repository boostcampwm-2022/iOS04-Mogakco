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
    func loadTagList(kind: KindHashtag) -> Observable<[Languages]> {
        return Observable.create { emitter in
            switch kind {
            case .language: emitter.onNext(loadLanguage())
            case .career: break
            case .category: break
            }
            
            return Disposables.create()
        }
    }
    
    private func loadLanguage() -> [Languages] {
        return Languages.allCases
    }
}
