//
//  StudySort.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum StudySort: CaseIterable {
    case latest, oldest
    
    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .oldest:
            return "오래된순"
        }
    }
}
