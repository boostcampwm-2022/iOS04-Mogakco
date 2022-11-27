//
//  MessageInputView.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MessageInputView: UIView {
    
    lazy var messageInputTextView = UITextView().then {
        $0.font = .mogakcoFont.smallRegular
        $0.textAlignment = .left
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 30)
        $0.isScrollEnabled = false
    }
    
    lazy var sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .mogakcoColor.primaryDefault
        $0.layer.cornerRadius = 12
    }
    
    lazy var placeholderLabel = UILabel().then {
        $0.text = "메세지를 입력해주세요."
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = .lightGray
    }
    
    private let disposeBag = DisposeBag()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private func layout() {
        layoutMessageInputView()
        layoutSendButton()
        configureMessageInputView()
        layoutPlaceholder()
    }
    
    private func configureUI() {
        backgroundColor = .white
        addShadow(offset: .init(width: 1, height: 1))
        autoresizingMask = .flexibleHeight
    }
    
    private func layoutMessageInputView() {
        addSubview(messageInputTextView)
        
        messageInputTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(13)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.height.lessThanOrEqualTo(80)
        }
    }
    
    private func layoutSendButton() {
        addSubview(sendButton)
        
        sendButton.snp.makeConstraints {
            $0.right.bottom.equalTo(messageInputTextView).inset(4)
            $0.width.height.equalTo(25)
        }
    }
    
    private func configureMessageInputView() {
        messageInputTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func layoutPlaceholder() {
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalTo(messageInputTextView)
            $0.left.equalTo(messageInputTextView.snp.left).inset(15)
        }
    }
}
