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
    
    private let bodyLabel = UILabel().then {
        $0.text = "text"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    init(_ body: String) {
        super.init(frame: .zero)
        layout(body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(_ body: String) {
        layoutCheckButton()
        layoutBodyLabel(body)
    }
    
    private func layoutCheckButton() {
        addSubview(checkButton)
        
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.left.equalToSuperview()
        }
    }
    
    private func layoutBodyLabel(_ body: String) {
        addSubview(bodyLabel)
        
        bodyLabel.snp.makeConstraints {
            $0.left.equalTo(checkButton.snp.right).offset(10)
            $0.right.equalToSuperview()
        }
        
        bodyLabel.text = body
    }
}
