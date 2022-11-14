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
    let largeRegular = UIFont(name: SFPro.regular.rawValue, size: 30)
    let mediumRegular = UIFont(name: SFPro.regular.rawValue, size: 18)
    let smallRegular = UIFont(name: SFPro.regular.rawValue, size: 14)

    // Bold
    let largeBold = UIFont(name: SFPro.bold.rawValue, size: 30)
    let title1Bold = UIFont(name: SFPro.bold.rawValue, size: 24)
    let title2Bold = UIFont(name: SFPro.bold.rawValue, size: 22)
    let title3Bold = UIFont(name: SFPro.bold.rawValue, size: 20)
    let mediumBold = UIFont(name: SFPro.bold.rawValue, size: 18)
    let smallBold = UIFont(name: SFPro.bold.rawValue, size: 14)
    let caption = UIFont(name: SFPro.bold.rawValue, size: 12)
}

enum SFPro: String {
    case regular = "SFProDisplay-Regular"
    case bold = "SFProDisplay-Semibold"
}
