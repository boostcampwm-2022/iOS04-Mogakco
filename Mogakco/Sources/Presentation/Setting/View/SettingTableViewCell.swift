//
//  SettingTableViewCell.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingTableViewCell: UITableViewCell, Identifiable {
    
    enum Constant {
        static let cellHeight = 60.0
    }
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.textColor = .mogakcoColor.typographyPrimary
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0))
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutCell()
        layoutTitleLabel()
    }
    
    private func layoutCell() {
        selectionStyle = .none
        backgroundColor = .mogakcoColor.backgroundDefault
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
