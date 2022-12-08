//
//  UIView+Gradient.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

extension UIView {
    func setGradient(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
