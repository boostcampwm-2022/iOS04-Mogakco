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
    
    // MARK: - UI
    
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textAlignment = .left
        $0.snp.makeConstraints { $0.left.equalToSuperview().inset(4) }
    }
    
    lazy var selectButton = UIButton().then {
        $0.configuration = configuration(title: "선택")
        $0.addShadow(offset: .init(width: 1, height: 1))
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 8
    }
    
    var selectLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textAlignment = .right
        $0.isHidden = true
    }
    
    let collectionView = UICollectionView().then {
        $0.register(BadgeCell.self, forCellWithReuseIdentifier: BadgeCell.identifier)
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
        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createTopStackView() -> UIStackView {
        let subviews = [titleLabel, selectButton, selectLabel]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
    }
    
    private func createTotalStackView() -> UIStackView {
        let subviews = [createTopStackView(), collectionView]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
    }
    
    private func configuration(title: String) -> UIButton.Configuration {
        
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
}
