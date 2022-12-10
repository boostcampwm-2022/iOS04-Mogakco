//
//  RectListSkeletonView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class StudyListSkeletonView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let cellCount = Int(frame.height / 130)
        let stackView = UIStackView().then {
            $0.spacing = 20
            $0.axis = .vertical
        }
        addSubview(stackView)
        
        (0..<cellCount).forEach { _ in
            stackView.addArrangedSubview(StudyListCellSkeletonView())
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
