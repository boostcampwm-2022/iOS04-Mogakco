//
//  UIImage+.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit

extension UIColor {
    static let mogakcoColor = MogakcoColor()
}

struct MogakcoColor {
    // Primary
    let primaryDefault = UIColor(named: "PrimaryDefault")
    let PrimarySecondary = UIColor(named: "PrimarySecondary")
    
    // Typography
    let TypographyPrimary = UIColor(named: "TypographyPrimary")
    let TypographySecondary = UIColor(named: "TypographySecondary")
    let TypopraphyDisabled = UIColor(named: "TypopraphyDisabled")
    
    // Semantic
    let SegmanticSuccess = UIColor(named: "SegmanticSuccess")
    let SemanticNegative = UIColor(named: "SemanticNegative")
    let SemanticDisabled = UIColor(named: "SemanticDisabled")
    
    // Border
    let BorderDefault = UIColor(named: "BorderDefault")
    
    // Background
    let BackgroundDefault = UIColor(named: "BackgroundDefault")
    let BackgroundSecondary = UIColor(named: "BackgroundSecondary")
}
