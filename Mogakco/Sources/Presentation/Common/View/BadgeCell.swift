//
//  BadgeCell.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class BadgeCell: UICollectionViewCell, Identifiable {
    static let addWidth = CGFloat(70)
    static let height = CGFloat(35)
    
    private let iconimageView = UIImageView(image: UIImage(systemName: "questionmark.app")).then {
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = .mogakcoFont.mediumRegular
        $0.textAlignment = .left
        $0.text = "Default"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutView()
        layoutIconImage()
        layoutTitle()
    }
    
    private func layoutView() {
        backgroundColor = .mogakcoColor.backgroundDefault
        layer.cornerRadius = CGFloat(10)
        addShadow(offset: CGSize(width: 2, height: 2))
    }
    
    private func layoutIconImage() {
        addSubview(iconimageView)
        iconimageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(30)
        }
    }
    
    private func layoutTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconimageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    override func prepareForReuse() {
        iconimageView.image = UIImage(systemName: "questionmark.app")
        titleLabel.text = "Default"
    }
    
    func setInfo(iconImage: UIImage?, title: String) {
        iconimageView.image = iconImage ?? UIImage(systemName: "questionmark.app")
        titleLabel.text = title
    }
}
