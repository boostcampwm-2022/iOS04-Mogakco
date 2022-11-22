//
//  HashtagSelectHeader.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class HashtagHeader: UICollectionReusableView, Identifiable {
    
    static let height = CGFloat(65)
    
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = .mogakcoFont.mediumBold
        $0.text = "사용하시는 언어를 선택해주세요!"
    }
    
    private let secondaryTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographySecondary
        $0.font = .mogakcoFont.smallRegular
        $0.numberOfLines = 2
        $0.text = "다중 선택 가능(최대 5개)\n첫 번째 언어가 주 언어가 됩니다."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubViews([mainTitleLabel, secondaryTitleLabel])
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        secondaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setTitle(kind: KindHashtag) {
        switch kind {
        case .language:
            mainTitleLabel.text = "사용하시는 언어를 선택해주세요!"
            secondaryTitleLabel.text = "다중 선택 가능(최대 5개)\n첫 번째 언어가 주 언어가 됩니다."
        case .career:
            mainTitleLabel.text = "경력을 선택해 주세요."
            secondaryTitleLabel.text = "다중 선택 가능(최대 5개)"
        case .category:
            mainTitleLabel.text = "카테고리를 선택해주세요."
            secondaryTitleLabel.text = "하나만 선택 가능"
        }
    }
}
