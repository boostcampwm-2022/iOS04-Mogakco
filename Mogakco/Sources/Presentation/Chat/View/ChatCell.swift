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
    
    let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    
    let bubbleContainer = UIView().then {
        $0.backgroundColor = .mogakcoColor.backgroundSecondary
        $0.layer.cornerRadius = 8
    }
    
    var chat: Chat? {
        didSet { configureChat() }
    }
    
    let disposeBag = DisposeBag()
    
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
        profileImageView.image = UIImage(systemName: "person")
        textView.text = nil
    }
    
    private func layout() {
        layoutProfileImageView()
        layoutBubbleContainerView()
        layoutTextView()
    }
    
    private func layoutProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(4)
        }
    }
    
    private func layoutBubbleContainerView() {
        addSubview(bubbleContainer)
        
        bubbleContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.lessThanOrEqualTo(250)
        }
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = true

//        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
    }
    
    private func layoutTextView() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalTo(bubbleContainer).inset(4)
            $0.left.right.equalTo(bubbleContainer).inset(12)
        }
    }
    
    private func configureMessage() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
    }
}
