//
//  ValidationButton.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

final class ValidationButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureEnableColor()
        configureDisableColor()
    }
    
    private func configureEnableColor() {
        setBackgroundColor(UIColor.mogakcoColor.segmanticSuccess ?? .systemGreen, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
    }
    
    private func configureDisableColor() {
        setBackgroundColor(UIColor.mogakcoColor.semanticDisabled ?? .systemGray, for: .disabled)
        setTitleColor(UIColor.white, for: .disabled)
    }
}
