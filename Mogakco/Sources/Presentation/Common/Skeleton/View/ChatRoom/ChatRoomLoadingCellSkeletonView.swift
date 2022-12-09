//
//  LoadingCellSkeletonView.swift
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

final class ChatRoomLoadingCellSkeletonView: UIView {
    
    override func layoutSubviews() {
        layout()
    }
    
    private func layout() {
        let rectView = LoadingView().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        addSubview(rectView)
        
        rectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(frame.width / 6)
            $0.bottom.equalToSuperview()
        }
        
        let spacing = 8
        let stackView = UIStackView().then {
            $0.spacing = CGFloat(spacing)
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        [1.5, 2.0].forEach {
            let firstBar = LoadingView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 10
            }
            stackView.addArrangedSubview(firstBar)
            
            let widthRatio = frame.width / $0
            
            firstBar.snp.makeConstraints {
                $0.height.equalTo(((Int(frame.width) / 6) - spacing * 2) / 2)
                $0.width.equalTo(widthRatio)
            }
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(rectView.snp.top)
            $0.leading.equalTo(rectView.snp.trailing).offset(spacing)
        }
    }
}
