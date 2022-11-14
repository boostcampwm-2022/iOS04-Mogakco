//
//  TextField.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

class TextField: UITextField {
    
    enum Validation {
        case none
        case valid
        case invalid
        
        var color: UIColor {
            switch self {
            case .none:
                return UIColor.mogakcoColor.semanticDisabled ?? UIColor.systemGray
            case .valid:
                return UIColor.mogakcoColor.semanticSuccess ?? UIColor.systemGreen
            case .invalid:
                return UIColor.mogakcoColor.semanticNegative ?? UIColor.systemRed
            }
        }
    }
    
    // MARK: Public
    
    final var validation: Validation = .none {
        didSet {
            layer.borderColor = validation.color.cgColor
        }
    }
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setup() {
        font = UIFont.mogakcoFont.mediumRegular
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = validation.color.cgColor
        leftViewMode = .always
        rightViewMode = .always
        leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
        rightView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    }
    
    private func layout() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}
