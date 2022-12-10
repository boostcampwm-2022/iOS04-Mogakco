//
//  UserProfileSkeletonView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/10.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class UserProfileSkeletonView: UIView {
    
    let profileImage = LoadingView()
    let profileInfo = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 8
    }
    let profileEditButton = LoadingView()
    
    let tagStackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.mogakcoColor.backgroundDefault
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutProafile()
        layoutTag()
    }
    
    private func layoutProafile() {
        profileImage.layer.cornerRadius = 60
        addSubview(profileImage)
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(120)
        }
        
        [0.5, 0.4].forEach {
            let loadingView = LoadingView()
            loadingView.layer.cornerRadius = 8
            let widthRatio = frame.width * $0
            loadingView.snp.makeConstraints {
                $0.width.equalTo(widthRatio)
                $0.height.equalTo(20)
            }
            profileInfo.addArrangedSubview(loadingView)
        }
        
        addSubview(profileInfo)
        profileInfo.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImage.snp.centerY)
        }
        
        profileEditButton.layer.cornerRadius = 8
        addSubview(profileEditButton)
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(35)
        }
    }
    
    private func layoutTag() {
        [0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.4, 1.0].enumerated().forEach { index, ratio in
            let loadingView = LoadingView()
            loadingView.layer.cornerRadius = 8
            let width = frame.width * ratio
            let height = ((index % 2) == 0) ? 25 : 35
            tagStackView.addArrangedSubview(loadingView)
            
            loadingView.snp.makeConstraints {
                $0.width.equalTo(width)
                $0.height.equalTo(height)
            }
        }
        
        addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(profileEditButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
