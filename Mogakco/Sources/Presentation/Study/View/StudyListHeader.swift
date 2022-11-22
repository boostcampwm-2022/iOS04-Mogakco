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
    
    let sortButton = UIButton().then {
        $0.configuration = configuration(title: "정렬")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let languageButton = UIButton().then {
        $0.configuration = configuration(title: "언어")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let categoryButton = UIButton().then {
        $0.configuration = configuration(title: "카테고리")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let resetButton = UIButton().then {
        $0.configuration = configuration(title: "초기화")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private lazy var bottomStackView = UIStackView(
        arrangedSubviews: [sortButton, languageButton, categoryButton, resetButton]
    ).then {
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
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
    
    private func bind() {
        
        sortButton.rx.tap
            .compactMap({ [weak self] in
                self?.sortButton.isSelected.toggle()
                let isSelected = self?.sortButton.isSelected
                return self?.borderColor(isSelected: isSelected ?? false)
            })
            .subscribe { [weak self] in
                self?.sortButton.layer.borderColor = $0.cgColor
            }
            .disposed(by: disposeBag)
        
        languageButton.rx.tap
            .compactMap({ [weak self] in
                self?.languageButton.isSelected.toggle()
                let isSelected = self?.languageButton.isSelected
                return self?.borderColor(isSelected: isSelected ?? false)
            })
            .subscribe { [weak self] in
                self?.languageButton.layer.borderColor = $0.cgColor
            }
            .disposed(by: disposeBag)
        
        categoryButton.rx.tap
            .compactMap({ [weak self] in
                self?.categoryButton.isSelected.toggle()
                let isSelected = self?.categoryButton.isSelected
                return self?.borderColor(isSelected: isSelected ?? false)
            })
            .subscribe { [weak self] in
                self?.categoryButton.layer.borderColor = $0.cgColor
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .compactMap({ [weak self] in
                self?.resetButton.isSelected.toggle()
                let isSelected = self?.resetButton.isSelected
                return self?.borderColor(isSelected: isSelected ?? false)
            })
            .subscribe { [weak self] in
                self?.resetButton.layer.borderColor = $0.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    private static func configuration(title: String) -> UIButton.Configuration {
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: SFPro.regular.rawValue, size: 13)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .mogakcoColor.typographyPrimary
        configuration.baseBackgroundColor = .mogakcoColor.backgroundDefault
        configuration.background.cornerRadius = 8
        configuration.attributedTitle = attributedTitle
        configuration.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        return configuration
    }
    
    private func borderColor(isSelected: Bool) -> UIColor {
        return isSelected ? UIColor.mogakcoColor.primaryDefault ?? .systemGreen : .clear
    }
}
