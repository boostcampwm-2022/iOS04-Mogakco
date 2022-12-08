//
//  StudyListHeader.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class StudyListHeader: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Top StackView
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.largeBold
        $0.text = "모각코"
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    let plusButton = UIButton().then {
        let plusImage = UIImage(systemName: "plus")
        $0.setImage(plusImage, for: .normal)
        $0.tintColor = .mogakcoColor.primaryDefault
    }
    
    private lazy var topStackView = UIStackView(
        arrangedSubviews: [titleLabel, plusButton]
    ).then {
        $0.distribution = .equalSpacing
    }
    
    // MARK: - Bottom StackView
    
    let sortButton = UIButton()
    
    let languageButton = UIButton()
    
    let categoryButton = UIButton()
    
    let resetButton = UIButton()
    
    private lazy var bottomStackView = UIStackView(
        arrangedSubviews: [sortButton, languageButton, categoryButton, resetButton]
    ).then {
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attributeButton()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func layout() {
        layoutTopStackView()
        layoutBottomStackView()
    }
    
    private func layoutTopStackView() {
        addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.height.equalTo(68)
            make.left.top.right.equalToSuperview()
        }
    }
    
    private func layoutBottomStackView() {
        addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topStackView.snp.bottom).offset(10)
        }
    }
    
    private func attributeButton() {
        zip(
            [sortButton, languageButton, categoryButton, resetButton],
            ["정렬", "언어", "카테고리", "초기화"]
        ).forEach {
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.borderWidth = 0.8
            $0.layer.cornerRadius = 8
            $0.setTitle($1, for: .normal)
            $0.titleLabel?.font = UIFont(name: SFPro.regular.rawValue, size: 14) ?? UIFont()
            $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
            $0.backgroundColor = UIColor.mogakcoColor.primaryThird
        }
    }
   
    func attributeButtonBorderColor(button: UIButton?) {
        guard let button = button else { return }
        button.layer.borderColor = borderColor(isSelected: button.isSelected).cgColor
    }
    
    private func borderColor(isSelected: Bool) -> UIColor {
        return isSelected ? UIColor.mogakcoColor.primaryDefault ?? .systemOrange : .clear
    }
}
