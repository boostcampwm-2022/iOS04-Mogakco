//
//  LanguageResponseDTO.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

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
    
    static func randomImageID() -> String {
        guard let id = Languages.allCases.randomElement()?.id else { return "swift" }
        return id
    }
    
    static func idToHashtag(id: String) -> Hashtag? {
        switch id {
        case "c": return Languages.cLang
        case "cShop": return Languages.cShop
        case "cpp": return Languages.cpp
        case "dart": return Languages.dart
        case "go": return Languages.goLang
        case "haskell": return Languages.haskell
        case "javaScript": return Languages.javaScript
        case "kotlin": return Languages.kotlin
        case "matlab": return Languages.matlab
        case "objectC": return Languages.objectC
        case "php": return Languages.php
        case "python": return Languages.python
        case "r": return Languages.rLang
        case "ruby": return Languages.ruby
        case "rust": return Languages.rust
        case "scratch": return Languages.scratch
        case "swift": return Languages.swift
        case "visualBasic": return Languages.visualBasic
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
