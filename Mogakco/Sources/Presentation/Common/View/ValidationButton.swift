//
//  ValidationButton.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import SnapKit

final class ValidationButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureFont()
        configureRadius()
        configureEnableColor()
        configureDisableColor()
    }
    
    private func configureFont() {
        titleLabel?.font = .mogakcoFont.mediumBold
    }
    
    private func configureRadius() {
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    private func configureEnableColor() {
        setBackgroundColor(UIColor.mogakcoColor.semanticSuccess ?? .systemGreen, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
    }
    
    private func configureDisableColor() {
        setBackgroundColor(UIColor.mogakcoColor.semanticDisabled ?? .systemGray, for: .disabled)
        setTitleColor(UIColor.white, for: .disabled)
    }
}
