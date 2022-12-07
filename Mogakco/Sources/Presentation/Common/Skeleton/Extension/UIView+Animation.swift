//
//  UIView+Animation.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

extension UIView {
    func loadinAnimation() {
        let gradient = CAGradientLayer()
        let colors = [UIColor.baseColor, UIColor.pointColor, UIColor.pointColor, UIColor.baseColor]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = colors.map { $0?.cgColor ?? UIColor.clear.cgColor }
        gradient.locations = [0, 0.2, 0.8, 1.0]
        layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.7, -0.3, 0.0]
        animation.toValue = [1.0, 1.3, 1.7, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(animation, forKey: animation.keyPath)
    }
}
