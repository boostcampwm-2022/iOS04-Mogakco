//
//  UIView+Shadow.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor = .lightGray, opacity: Float = 0.35, radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func removeShadow() {
        layer.shadowOpacity = Float(0.0)
    }
}
