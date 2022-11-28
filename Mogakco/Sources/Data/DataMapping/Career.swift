//
//  Career.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum Career: String, CaseIterable, Hashtag {
    case baemin
    case carrot
    case facebook
    case kakao
    case line
    case naver
    case toss
    case worksMobile
    
    var title: String {
        return self.rawValue
    }
    
    var displayTitle: String {
        switch self {
        case .baemin: return "배달의민족"
        case .carrot: return "당근마켓"
        case .facebook: return "페이스북(메타)"
        case .kakao: return "카카오"
        case .line: return "라인"
        case .naver: return "네이버"
        case .toss: return "토스"
        case .worksMobile: return "웍스모바일"
        }
    }
}
