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
    func loadTagList(kind: KindHashtag) -> Observable<[String]> {
        return Observable.create { emitter in
            switch kind {
            case .language: emitter.onNext(loadLanguage())
            case .career: break
            case .category: break
            }
            
            return Disposables.create()
        }
    }
    
    private func loadLanguage() -> [String] {
        return Languages.allNames()
    }
    
    enum Languages: String, CaseIterable {
        case cLang = "c"
        case cShop
        case cpp
        case dart
        case goLang = "go"
        case haskell
        case javaScript
        case kotlin
        case matlab
        case objectC
        case php
        case python
        case rLang = "r" // Lint 3자 제한 때문
        case ruby
        case rust
        case scratch
        case swift
        case visualBasic
        
        static func allNames() -> [String] {
            var names: [String] = []
            self.allCases.forEach {
                names.append($0.rawValue)
            }
            
            return names
        }
    }
}
