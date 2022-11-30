//
//  Animation.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum Animation {
    static let iconCount: Int = 5
    static let IconSize: Int = 100
    static let moveInterval = 0.017
    static let rotateDuration = 10
    
    static let zero: CGFloat = 0
    static let nagativeDirection: CGFloat = -2
    static let positiveDirection: CGFloat = 2
    static let directionProbability: [CGFloat] = [
        nagativeDirection,
        nagativeDirection,
        nagativeDirection,
        nagativeDirection,
        zero,
        positiveDirection,
        positiveDirection,
        positiveDirection,
        positiveDirection
    ]
}
