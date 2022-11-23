//
//  StudySelectView.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class StudySelectView: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String = "" {
        didSet {
            button.configuration = plain(title: content)
            button.removeShadow()
        }
    }
    
    // MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textAlignment = .left
    }
    
    lazy var button = UIButton().then {
        $0.configuration = rounded(title: "선택")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.cornerRadius = 5
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let totalStackView = createTotalStackView()
        addSubview(totalStackView)
        totalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(4)
        }
    }
    
    private func createTotalStackView() -> UIStackView {
        let subviews = [titleLabel, button]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
    }
    
    private func rounded(title: String) -> UIButton.Configuration {
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: SFPro.regular.rawValue, size: 13)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .mogakcoColor.typographyPrimary
        configuration.baseBackgroundColor = .mogakcoColor.backgroundDefault
        configuration.background.cornerRadius = 5
        configuration.attributedTitle = attributedTitle
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        
        return configuration
    }
    
    private func plain(title: String) -> UIButton.Configuration {
     
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: SFPro.regular.rawValue, size: 16)
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .mogakcoColor.typographyPrimary
        configuration.attributedTitle = attributedTitle
        configuration.contentInsets = .zero
        
        return configuration
    }
}
