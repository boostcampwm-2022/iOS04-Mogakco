//
//  Validation.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

enum Validation {
    case none
    case valid
    case invalid
    
    var color: UIColor {
        switch self {
        case .none:
            return UIColor.mogakcoColor.semanticDisabled ?? UIColor.systemGray
        case .valid:
            return UIColor.mogakcoColor.semanticSuccess ?? UIColor.systemGreen
        case .invalid:
            return UIColor.mogakcoColor.semanticNegative ?? UIColor.systemRed
        }
    }
}
