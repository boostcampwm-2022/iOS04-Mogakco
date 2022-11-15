//
//  TitleHeaderView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class TitleHeaderView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.largeBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    private func layout() {
        layoutTitleLabel()
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }
    }
    
}
