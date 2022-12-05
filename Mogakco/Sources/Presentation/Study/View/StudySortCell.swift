//
//  StudySortCell.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class StudySortCell: UICollectionViewCell, Identifiable {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 13)
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(studySort: StudySort) {
        titleLabel.text = studySort.title
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8.0)
        }
    }
    
    private func attribute() {
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.mogakcoColor.primarySecondary?.cgColor
        layer.cornerRadius = 8.0
    }
}
