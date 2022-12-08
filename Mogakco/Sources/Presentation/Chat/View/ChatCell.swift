//
//  ChatCell.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import Then

final class ChatCell: UICollectionViewCell, Identifiable {
    
    private let profileImageView = RoundProfileImageView(35)
    
    let profileImageButton = UIButton()
    
    let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    let bubbleContainer = UIView().then {
        $0.backgroundColor = .mogakcoColor.primarySecondary
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.isHidden = false
        profileImageView.image = UIImage(systemName: "person")
        textView.text = nil
        bubbleContainer.snp.removeConstraints()
    }
    
    private func layout() {
        layoutCell()
        layoutProfileImageView()
        layoutProfileImageButton()
        layoutBubbleContainerView()
        layoutTextView()
    }
    
    private func layoutCell() {
        backgroundColor = .mogakcoColor.backgroundDefault
    }
    
    private func layoutProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(4)
        }
    }
    
    private func layoutProfileImageButton() {
        addSubview(profileImageButton)
        
        profileImageButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
    }
    
    private func layoutBubbleContainerView() {
        addSubview(bubbleContainer)
        
        bubbleContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(200)
        }
    }
    
    private func layoutTextView() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalTo(bubbleContainer).inset(4)
            $0.left.right.equalTo(bubbleContainer).inset(12)
        }
    }
    
    func layoutChat(chat: Chat) {
        guard
            let isFromCurrentUser = chat.isFromCurrentUser,
            let user = chat.user else {
            textView.text = chat.message
            return layoutOthersBubble(image: UIImage(systemName: "person.fill")) }

        if isFromCurrentUser {
            layoutMyBubble()
        } else {
            layoutOthersBubble(user: user)
        }
        
        textView.text = chat.message
    }
    
    private func layoutOthersBubble(user: User? = nil, image: UIImage? = nil) {
        bubbleContainer.snp.remakeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.width.lessThanOrEqualTo(200)
        }
        bubbleContainer.backgroundColor = .mogakcoColor.primarySecondary
        
        if let image = image {
            profileImageView.image = image
        }
        
        if let user = user,
           let urlStr = user.profileImageURLString,
           let url = URL(string: urlStr) {
            profileImageView.load(url: url)
        }
    }
    
    private func layoutMyBubble() {
        bubbleContainer.snp.remakeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.width.lessThanOrEqualTo(200)
        }
        bubbleContainer.backgroundColor = .mogakcoColor.primaryDefault
        profileImageView.isHidden = true
    }
}
