//
//  LanguageResponseDTO.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

enum Language: String, CaseIterable, Hashtag {
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
    
    static func randomImageID() -> String {
        guard let id = Language.allCases.randomElement()?.id else { return "swift" }
        return id
    }
    
    static func idToHashtag(id: String) -> Hashtag? {
        switch id {
        case "c": return Language.cLang
        case "cShop": return Language.cShop
        case "cpp": return Language.cpp
        case "dart": return Language.dart
        case "go": return Language.goLang
        case "haskell": return Language.haskell
        case "javaScript": return Language.javaScript
        case "kotlin": return Language.kotlin
        case "matlab": return Language.matlab
        case "objectC": return Language.objectC
        case "php": return Language.php
        case "python": return Language.python
        case "r": return Language.rLang
        case "ruby": return Language.ruby
        case "rust": return Language.rust
        case "scratch": return Language.scratch
        case "swift": return Language.swift
        case "visualBasic": return Language.visualBasic
        default: return nil
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var title: String {
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
    
    var image: UIImage {
        return UIImage(named: id) ?? UIImage()
    }
}
