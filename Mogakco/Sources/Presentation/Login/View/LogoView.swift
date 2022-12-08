//
//  LogoView.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class LogoView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "모 여서\n각 자\n코 딩하자 👨🏻‍💻"
        $0.numberOfLines = 0
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "개발자 스터디 통합 플랫폼"
        $0.font = UIFont.mogakcoFont.smallBold
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubViews([titleLabel, subtitleLabel])
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
    }
    
    private func setupTitle() {
        let text = titleLabel.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        
        let heads = [
            (text as NSString).range(of: "모"),
            (text as NSString).range(of: "각"),
            (text as NSString).range(of: "코")
        ]
        
        heads.forEach {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.mogakcoColor.primaryDefault as Any,
                range: $0
            )
        }

        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: SFPro.bold.rawValue, size: 27) as Any,
            .strokeWidth: -3
        ]
        
        attributedString.addAttributes(attrs, range: (text as NSString).range(of: text))
        titleLabel.attributedText = attributedString
    }
}
