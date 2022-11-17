//
//  UIViewController+HalfModal.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

extension UIViewController {
    
    func halfModal(_ title: String, _ subTitle: String) {
        let modalVC = HalfModalViewController(title, subTitle)
        modalVC.modalPresentationStyle = .pageSheet
        guard let sheet = modalVC.sheetPresentationController else { return }
        sheet.detents = [
            .custom(resolver: { _ in
                return 180
            })
        ]
        sheet.prefersGrabberVisible = true
        
        present(modalVC, animated: true)
    }
}
