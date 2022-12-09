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
        
        let firstBar = LoadingView().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        addSubview(firstBar)
        
        let spacing = 16
        
        firstBar.snp.makeConstraints {
            $0.top.equalTo(rectView.snp.top)
            $0.leading.equalTo(rectView.snp.trailing).offset(spacing)
            $0.height.equalTo(Int(frame.width / 6) / 2 - spacing / 2)
            $0.width.equalTo(frame.width / 1.5)
        }
        
        let secondBar = LoadingView().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        addSubview(secondBar)
        
        secondBar.snp.makeConstraints {
            $0.top.equalTo(firstBar.snp.bottom).offset(10)
            $0.leading.equalTo(rectView.snp.trailing).offset(spacing)
            $0.height.equalTo(Int(frame.width / 6) / 2 - spacing / 2)
            $0.width.equalTo(frame.width / 2)
        }
    }
}
