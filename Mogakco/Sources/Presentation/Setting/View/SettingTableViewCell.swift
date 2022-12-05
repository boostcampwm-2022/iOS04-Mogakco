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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        selectionStyle = .none
        layoutTitleLabel()
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
