//
//  MessageTextField.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MessageTextField: UIView {
    
    // MARK: Public
    
    var validation: TextField.Validation = .none {
        didSet {
            textField.validation = validation
            label.textColor = validation.color
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }

    var message: String = "" {
        didSet {
            label.text = message
        }
    }
    
    // MARK: Private
    
    fileprivate let textField: TextField
    
    private let label = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallRegular
    }
    
    // MARK: Inits
    
    init(isSecure: Bool = false) {
        textField = isSecure ? SecureTextField() : TextField()
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func layout() {
        layoutTextField()
        layoutLabel()
    }
    
    private func layoutTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    private func layoutLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
            make.top.equalTo(textField.snp.bottom).offset(4)
        }
    }
}

extension Reactive where Base: MessageTextField {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
    var validation: Binder<TextField.Validation> {
        return Binder(self.base) { view, validation in
            view.validation = validation
        }
    }
}
