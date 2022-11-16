//
//  UIFont+CustomFont.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/14.
//

import UIKit

extension UIFont {
    static let mogakcoFont = MogakcoFont()
}

struct MogakcoFont {
    
    // Regular
    let largeRegular = MogakcoFontFamily.SFProDisplay.regular.font(size: 30)
    let mediumRegular = MogakcoFontFamily.SFProDisplay.regular.font(size: 18)
    let smallRegular = MogakcoFontFamily.SFProDisplay.regular.font(size: 14)

    // Bold
    let largeBold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 30)
    let title1Bold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 24)
    let title2Bold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 22)
    let title3Bold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 20)
    let mediumBold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 18)
    let smallBold = MogakcoFontFamily.SFProDisplay.semibold.font(size: 14)
    let caption = MogakcoFontFamily.SFProDisplay.semibold.font(size: 12)
}

enum SFPro: String {
    case regular = "SFProDisplay-Regular"
    case bold = "SFProDisplay-Semibold"
}
