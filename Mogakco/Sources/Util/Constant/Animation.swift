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
    static let nagativeVelocity: CGFloat = -1
    static let positiveVelocity: CGFloat = 1
    static let directionProbability: [CGFloat] = [
        nagativeVelocity,
        nagativeVelocity,
        nagativeVelocity,
        nagativeVelocity,
        zero,
        positiveVelocity,
        positiveVelocity,
        positiveVelocity,
        positiveVelocity
    ]
}
