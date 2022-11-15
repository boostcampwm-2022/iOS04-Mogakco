//
//  CheckBoxView.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class CheckBoxView: UIView {
    
    let isCheck = false
    
    private let checkButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
    }
    
    private let textLabel = UILabel().then {
        $0.text = "text"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    init(_ text: String) {
        super.init(frame: .zero)
        layout(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(_ text: String) {
        layoutCheckButton()
        layoutBodyLabel(text)
    }
    
    private func layoutCheckButton() {
        addSubview(checkButton)
        
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.left.equalToSuperview()
        }
    }
    
    private func layoutBodyLabel(_ text: String) {
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.left.equalTo(checkButton.snp.right).offset(10)
            $0.right.equalToSuperview()
        }
        
        textLabel.text = text
    }
}

enum WithdrawReason: String {
    
    case deleteInformation = "개인정보 삭제 목적"
    case inconvenience = "이용이 불편하고 장애가 많아서"
    case otherApp = "다른 앱이 더 좋아서"
    case duplicateAccount = "중복 계정이 있어서"
    case lowUsage = "사용 빈도가 낮아서"
    case dissatisfaction = "콘텐츠 불만이 있어서"
    case etc = "기타"
    
    var checkBox: CheckBoxView {
        return CheckBoxView(self.rawValue)
    }
}
