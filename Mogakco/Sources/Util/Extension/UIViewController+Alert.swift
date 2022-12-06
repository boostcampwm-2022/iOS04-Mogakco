//
//  UIViewController+Alert.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    
    static func cancel() -> UIAlertAction {
        return UIAlertAction(title: "취소", style: .cancel)
    }
    
    static func destructive(title: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
}
