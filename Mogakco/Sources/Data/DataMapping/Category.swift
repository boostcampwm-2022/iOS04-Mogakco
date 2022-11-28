//
//  Category.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

enum Category: String, CaseIterable, Hashtag {
    case artificialIntelligence = "ai"
    case algorithm
    case android
    case backend
    case bigdata
    case contest
    case computerScience = "cs"
    case frontend
    case hackathon
    case iOS = "ios"
    case interview
    case machineLearning
    
    var id: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .artificialIntelligence: return "AI"
        case .algorithm: return "알고리즘"
        case .android: return "안드로이드"
        case .backend: return "백엔드"
        case .bigdata: return "빅데이터"
        case .contest: return "공모전"
        case .computerScience: return "CS"
        case .frontend: return "프론트엔드"
        case .hackathon: return "해커톤"
        case .iOS: return "iOS"
        case .interview: return "인터뷰"
        case .machineLearning: return "머신러닝"
        }
    }
    
    var image: UIImage {
        return UIImage(named: id) ?? UIImage()
    }
}
