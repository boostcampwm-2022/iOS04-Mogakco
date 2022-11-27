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
    }
    
    private func layoutTextView() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalTo(bubbleContainer).inset(4)
            $0.left.right.equalTo(bubbleContainer).inset(12)
        }
    }
    
    private func configureChat() {
        guard let chat = chat else { return }
        let chatDataSource = ChatDataSource()
        let localUserDataSource = UserDefaultsUserDataSource()
        let remoteUserDataSource = RemoteUserDataSource(provider: Provider.default)
        
        let chatRepository = ChatRepository(chatDataSource: chatDataSource)
        let userRepository = UserRepository(
            localUserDataSource: localUserDataSource,
            remoteUserDataSource: remoteUserDataSource
        )
        
        let chatUseCase = ChatUseCase(
            chatRepository: chatRepository,
            userRepository: userRepository
        )
        
        let viewModel = MessageViewModel(
            chat: chat,
            chatUseCase: chatUseCase
        )
        
        let output = viewModel.transform()
        print("@", 2)
        output.isFromCurrentUser
            .subscribe { [weak self] bool in
                print("@@", bool.element)
                
            }.disposed(by: disposeBag)
        print("@", 3)
        output.isFromCurrentUser
            .map { $0 ? UIColor.mogakcoColor.backgroundSecondary : UIColor.mogakcoColor.primaryDefault }
            .bind(to: bubbleContainer.rx.backgroundColor)
            .disposed(by: disposeBag)
        print("@", 4)
        output.isFromCurrentUser
            .withUnretained(self)
            .subscribe { _, bool in
                
                if bool {
                    self.layoutMyBubble()
                    print("DEBUG : true")
                } else {
                    self.layoutOthersBubble()
                    print("DEBUG : false")
                }
            }
            .disposed(by: disposeBag)
        print("@", 5)
        textView.text = chat.message
    }
    
    private func layoutOthersBubble() {
        bubbleContainer.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
    }
    
    private func layoutMyBubble() {
        bubbleContainer.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
        }
        profileImageView.isHidden = true
    }
}
