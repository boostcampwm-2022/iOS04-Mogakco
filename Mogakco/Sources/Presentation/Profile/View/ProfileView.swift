//
//  ProfileView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class ProfileView: UIView {
    
    let roundProfileImageView = RoundProfileImageView(120.0).then {
        $0.snp.makeConstraints {
            $0.size.equalTo(120.0)
        }
    }
    
    let roundLanguageImageView = RoundProfileImageView(45.0).then {
        $0.snp.makeConstraints {
            $0.size.equalTo(45.0)
        }
        $0.setPhoto(MogakcoAsset.swift.image)
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .left
    }
    
    let introduceLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.caption
        $0.textColor = .mogakcoColor.typographySecondary
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let chatButton = UIButton().then {
        $0.addShadow(offset: .init(width: 5.0, height: 5.0))
        $0.layer.cornerRadius = 12.0
        $0.setTitle("채팅", for: .normal)
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallBold
        $0.setBackgroundColor(.white, for: .normal)
    }
    
    let editProfileButton = UIButton().then {
        $0.addShadow(offset: .init(width: 3.0, height: 3.0))
        $0.layer.cornerRadius = 14.0
        $0.setTitle("프로필 편집", for: .normal)
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallBold
        $0.setBackgroundColor(.white, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutRoundProfileImageView()
        layoutRoundLanguageImageView()
        layoutLabelStackView()
        layoutButtonStackView()
    }
    
    private func layoutRoundProfileImageView() {
        addSubview(roundProfileImageView)
        roundProfileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().offset(16.0)
        }
    }
    
    private func layoutRoundLanguageImageView() {
        addSubview(roundLanguageImageView)
        roundLanguageImageView.snp.makeConstraints {
            $0.center.equalTo(roundProfileImageView).offset(40.0)
        }
    }
    
    private func layoutLabelStackView() {
        let stackView = createLabelStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(roundProfileImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(roundProfileImageView)
        }
    }

    private func createLabelStackView() -> UIStackView {
        let arrangeSubviews = [nameLabel, introduceLabel]
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .vertical
            $0.spacing = 4.0
        }
    }
    
    private func layoutButtonStackView() {
        let stackView = createButtonStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16.0)
            $0.top.equalTo(roundProfileImageView.snp.bottom).offset(16.0)
        }
    }
    
    private func createButtonStackView() -> UIStackView {
        let arrangeSubviews = [chatButton, editProfileButton]
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 16.0
            $0.distribution = .fillEqually
        }
    }
}
