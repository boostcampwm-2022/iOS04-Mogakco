//
//  LanguageResponseDTO.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum Languages: String, CaseIterable, Hashtag {
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
    
    var title: String {
        return self.rawValue
    }
    
    func hashtagTitle() -> String {
        switch self {
        case .cLang: return "C"
        case .cShop: return "C#"
        case .cpp: return "C++"
        case .dart: return "Dart"
        case .goLang: return "Go"
        case .haskell: return "Haskell"
        case .javaScript: return "JavaScript"
        case .kotlin: return "Kotlin"
        case .matlab: return "Matlab"
        case .objectC: return "Objective-C"
        case .php: return "PHP"
        case .python: return "Python"
        case .rLang: return "R"
        case .ruby: return "Ruby"
        case .rust: return "Rust"
        case .scratch: return "Scratch"
        case .swift: return "Swift"
        case .visualBasic: return "Visual Basic"
        }
    }
}
