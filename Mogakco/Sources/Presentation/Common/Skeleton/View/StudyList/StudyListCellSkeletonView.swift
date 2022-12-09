//
//  RectLoadingCellSkeletonView.swift
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

final class StudyListCellSkeletonView: UIView {
    
    override func layoutSubviews() {
        layout()
    }
    
    private func layout() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = UIColor.baseColor
        
        let stackView = UIStackView().then {
            $0.alignment = .leading
            $0.spacing = 5
            $0.axis = .vertical
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        [0.5, 0.9, 0.8, 0.3, 1.0, 1.0].forEach {
            let bar = LoadingView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 5
            }
            stackView.addArrangedSubview(bar)
            
            let widthRatio = frame.width * $0
            
            bar.snp.makeConstraints {
                $0.height.equalTo(15)
                $0.width.equalTo(widthRatio)
            }
        }
    }
}
