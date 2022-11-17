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
    static let addWidth = CGFloat(60)
    static let height = CGFloat(35)
    
    private let iconimageView = UIImageView(image: UIImage(systemName: "questionmark.app")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
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
        layer.cornerRadius = 10
        layer.borderColor = UIColor.gray.cgColor
        deselect()
    }
    
    private func layoutIconImage() {
        addSubview(iconimageView)
        iconimageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(20)
        }
    }
    
    private func layoutTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconimageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconimageView.image = UIImage(systemName: "questionmark.app")
        titleLabel.text = "Default"
    }
    
    func setInfo(iconName: String?, title: String?) {
        iconimageView.image = UIImage(named: iconName ?? "" ) ?? UIImage(systemName: "questionmark.app")
        titleLabel.text = title ?? "??"
    }
    
    func select() {
        backgroundColor = .mogakcoColor.backgroundSecondary
        layer.borderWidth = 0.5
        removeShadow()
    }
    
    func deselect() {
        backgroundColor = .mogakcoColor.backgroundDefault
        layer.borderWidth = 0
        addShadow(offset: CGSize(width: 4, height: 2))
    }
}
