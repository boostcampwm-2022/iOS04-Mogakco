//
//  ChatCell.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import Then

final class ChatCell: UICollectionViewCell, Identifiable {
    
    private let profileImageView = RoundProfileImageView(32)
    
    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.text = "HelloWorldHelloWorldHelloWorldHelloWorldHelloWorldHelloWorld"
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    
    private let bubbleContainer = UIView().then {
        $0.backgroundColor = UIColor.mogakcoColor.primarySecondary
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutProfileImageView()
        layoutBubbleContainerView()
        layoutTextView()
    }
    
    private func layoutProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-4)
        }
    }
    
    private func layoutBubbleContainerView() {
        addSubview(bubbleContainer)
        
        bubbleContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.width.lessThanOrEqualTo(250)
        }
    }
    
    private func layoutTextView() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalTo(bubbleContainer).inset(4)
            $0.left.right.equalTo(bubbleContainer).inset(12)
        }
    }
}
