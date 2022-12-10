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
    
    let titleView = LoadingView()
    let infoStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
        $0.alignment = .leading
    }
    let studyInfo = LoadingView()
    let languageTitle = LoadingView()
    let languageStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
    }
    let participantTitle = LoadingView()
    let participantStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.baseColor
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutStackView()
        layoutConstraints()
    }
    
    private func layoutStackView() {
        [0.7, 0.3, 0.2].forEach {
            let info = LoadingView()
            let widthRatio = frame.width * $0
            infoStack.addArrangedSubview(info)
            info.snp.makeConstraints {
                $0.width.equalTo(widthRatio)
            }
        }
        (0..<3).forEach { _ in
            let hashtag = LoadingView()
            let widthRatio = frame.width * 0.25
            languageStack.addArrangedSubview(hashtag)
            hashtag.snp.makeConstraints {
                $0.width.equalTo(widthRatio)
                $0.height.equalTo(35)
            }
        }
        (0..<3).forEach { _ in
            let participant = LoadingView()
            participantStack.addArrangedSubview(participant)
            participant.snp.makeConstraints {
                $0.width.equalTo(110)
                $0.height.equalTo(130)
            }
        }
    }
    
    private func layoutConstraints() {
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        addSubview(infoStack)
        infoStack.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(studyInfo)
        studyInfo.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(frame.width * 0.8)
            $0.height.equalTo(20)
        }
        
        addSubview(languageTitle)
        languageTitle.snp.makeConstraints {
            $0.top.equalTo(studyInfo.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        addSubview(languageStack)
        languageStack.snp.makeConstraints {
            $0.top.equalTo(languageTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        addSubview(participantTitle)
        participantTitle.snp.makeConstraints {
            $0.top.equalTo(languageStack.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        addSubview(participantStack)
        participantStack.snp.makeConstraints {
            $0.top.equalTo(participantTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
    }
}

