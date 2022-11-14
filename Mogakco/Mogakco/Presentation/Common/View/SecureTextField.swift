//
//  SecureTextField.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class SecureTextField: TextField {
    
    override func setup() {
        super.setup()
        isSecureTextEntry = true
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .systemGray
        
        let action = UIAction { [weak self] action in
            if let button = action.sender as? UIButton {
                button.isSelected.toggle()
                self?.isSecureTextEntry.toggle()
            }
        }
        
        let button = UIButton(configuration: config, primaryAction: action)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        
        rightView = button
    }
}
