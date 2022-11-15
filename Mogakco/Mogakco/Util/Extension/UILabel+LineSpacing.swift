//
//  UILabel+LineSpacing.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/15.
//

import UIKit

extension UILabel {
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        self.attributedText = attributedString
    }
}
