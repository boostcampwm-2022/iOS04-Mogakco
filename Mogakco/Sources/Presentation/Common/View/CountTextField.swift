//
//  CountTextField.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/15.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift

final class CountTextField: UIView {
    
    // MARK: Public
    
    var validation: TextField.Validation = .none {
        didSet {
            textField.validation = validation
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.mogakcoColor.typographySecondary ?? .white]
            )
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var maxCount: Int = -1 {
        didSet {
            update()
        }
    }
    
    // MARK: Private
    
    fileprivate let textField: TextField
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textAlignment = .left
    }
    
    private let countLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 14)
        $0.textAlignment = .right
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init(isSecure: Bool = false) {
        textField = isSecure ? SecureTextField() : TextField()
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func bind() {
        disposable = textField.rx.text
            .subscribe { [weak self] _ in
                self?.update()
            }
    }
    
    private func update() {
        let maxCount = maxCount < 0 ? Int.max : maxCount
        if let str = textField.text?.prefix(maxCount) {
            textField.text = String(str)
        }
        countLabel.isHidden = maxCount == Int.max ? true : false
        countLabel.text = "\(textField.text?.count ?? 0)/\(maxCount)"
    }
    
    private func layout() {
        layoutStackView()
        layoutTextField()
    }
    
    private func layoutStackView() {
        [titleLabel, countLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(30.0)
        }
    }
    
    private func layoutTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(8)
        }
    }
}

extension Reactive where Base: CountTextField {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
}
