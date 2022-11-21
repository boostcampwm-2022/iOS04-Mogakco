//
//  TextView.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

final class TextView: UITextView {
    
    // MARK: Public
    
    var placeholder: String? {
        didSet {
            label.text = placeholder
        }
    }
    
    // MARK: Private
    
    private let label = UILabel().then {
        $0.font = UIFont.mogakcoFont.mediumRegular
        $0.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
        $0.numberOfLines = 0
    }
    
    private var disposeBag = DisposeBag()
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    
    private func setup() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = (UIColor.mogakcoColor.semanticDisabled ?? .systemGray).cgColor
        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textContainer.lineFragmentPadding = 0
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        setupFont()
    }
    
    private func setupFont() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.font: UIFont.mogakcoFont.mediumRegular
        ]
        typingAttributes = attributes
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(Layout.textViewHeight)
        }
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        self.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.label.isHidden = true
            })
            .disposed(by: disposeBag)

        self.rx.didEndEditing
            .filter { [weak self] in
                self?.text.isEmpty ?? true
            }
            .subscribe(onNext: { [weak self] in
                self?.label.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}
