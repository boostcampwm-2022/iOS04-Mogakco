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
    let primarySecondary = UIColor(named: "PrimarySecondary")
    
    // Typography
    let typographyPrimary = UIColor(named: "TypographyPrimary")
    let typographySecondary = UIColor(named: "TypographySecondary")
    let typopraphyDisabled = UIColor(named: "TypopraphyDisabled")
    
    // Semantic
    let semanticSuccess = UIColor(named: "SemanticSuccess")
    let semanticNegative = UIColor(named: "SemanticNegative")
    let semanticDisabled = UIColor(named: "SemanticDisabled")
    
    // Border
    let borderDefault = UIColor(named: "BorderDefault")
    
    // Background
    let backgroundDefault = UIColor(named: "BackgroundDefault")
    let backgroundSecondary = UIColor(named: "BackgroundSecondary")
}
