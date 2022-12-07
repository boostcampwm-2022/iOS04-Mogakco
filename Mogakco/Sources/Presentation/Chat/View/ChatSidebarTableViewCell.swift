//
//  ChatSidebarTableViewCell.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class ChatSidebarTableViewCell: UITableViewCell, Identifiable {
    
    static let cellHeight = 60.0
    
    var menuLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .mogakcoFont.mediumRegular
        $0.textColor = .mogakcoColor.primaryDefault
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutSelf()
        layoutMenuLabel()
    }
    
    private func layoutSelf() {
        selectionStyle = .none
    }
    
    private func layoutMenuLabel() {
        addSubview(menuLabel)
        
        menuLabel.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(5)
        }
    }
}
