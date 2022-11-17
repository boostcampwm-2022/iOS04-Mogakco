//
//  StudyTitleLabel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class StudyTitleLabel: UILabel {
    
    convenience init(title: String) {
        self.init(frame: .zero)
        text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        textColor = .mogakcoColor.typographyPrimary
        font = UIFont.mogakcoFont.mediumBold
    }
}
