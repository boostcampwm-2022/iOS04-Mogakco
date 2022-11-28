//
//  Career.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

enum Career: String, CaseIterable, Hashtag {
    case baemin
    case carrot
    case facebook
    case kakao
    case line
    case naver
    case toss
    case worksMobile
    
    static func idToHashtag(id: String) -> Hashtag? {
        switch id {
        case "baemin": return Career.baemin
        case "carrot": return Career.carrot
        case "facebook": return Career.facebook
        case "kakao": return Career.kakao
        case "line": return Career.line
        case "naver": return Career.naver
        case "toss": return Career.toss
        case "worksMobile": return Career.worksMobile
        default: return nil
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var title: String {
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
    
    var image: UIImage {
        return UIImage(named: id) ?? UIImage()
    }
}
