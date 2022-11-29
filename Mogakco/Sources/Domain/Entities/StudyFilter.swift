//
//  StudyFilter.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum StudyFilter: Equatable {
    case languages([String])
    case category(String)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.languages, .languages), (.category, .category):
            return true
        default:
            return false
        }
    }
}
