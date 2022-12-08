//
//  UINavigation+Swipe.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
