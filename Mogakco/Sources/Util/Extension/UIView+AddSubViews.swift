//
//  UIView+AddSubViews.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit

extension UIView {
    func addSubViews(_ subViews: [UIView]) {
        subViews.forEach { addSubview($0) }
    }
}
