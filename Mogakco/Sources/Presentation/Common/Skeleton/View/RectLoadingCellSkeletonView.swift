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

final class RectLoadingCellSkeletonView: UIView {
    
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
        
        let firstBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(firstBar)
        
        firstBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width * 0.5)
        }
        
        let secondBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(secondBar)
        
        secondBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width * 0.9)
        }
        
        let thirdBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(thirdBar)
        
        thirdBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width * 0.8)
        }
        
        let fourthBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(fourthBar)
        
        fourthBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width * 0.3)
        }
        
        let fifthBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(fifthBar)
        
        fifthBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width)
        }
        
        let sixthBar = LoadingView().then {
            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
        }
        stackView.addArrangedSubview(sixthBar)
        
        sixthBar.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(frame.width)
        }
    }
}
