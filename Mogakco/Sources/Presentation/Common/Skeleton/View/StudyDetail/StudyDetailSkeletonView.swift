//
//  StudyDetailSkeletonView.swift
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

final class StudyDetailSkeletonView: UIView {
    
    let titleView = LoadingView().then {
        $0.layer.cornerRadius = 8
    }
    let infoStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
        $0.alignment = .leading
    }
    let studyInfo = LoadingView().then {
        $0.layer.cornerRadius = 8
    }
    let languageTitle = LoadingView().then {
        $0.layer.cornerRadius = 8
    }
    let languageStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
    }
    let participantTitle = LoadingView().then {
        $0.layer.cornerRadius = 8
    }
    let participantStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
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
        layoutStackView()
        layoutConstraints()
    }
    
    private func layoutStackView() {
        [0.7, 0.5, 0.6].forEach {
            let info = LoadingView()
            info.layer.cornerRadius = 8
            let widthRatio = frame.width * $0
            infoStack.addArrangedSubview(info)
            info.snp.makeConstraints {
                $0.width.equalTo(widthRatio)
                $0.height.equalTo(15)
            }
        }
        (0..<3).forEach { _ in
            let hashtag = LoadingView()
            hashtag.layer.cornerRadius = 8
            let widthRatio = frame.width * 0.2
            languageStack.addArrangedSubview(hashtag)
            hashtag.snp.makeConstraints {
                $0.width.equalTo(widthRatio)
                $0.height.equalTo(35)
            }
        }
        (0..<3).forEach { _ in
            let participant = LoadingView()
            participant.layer.cornerRadius = 8
            participantStack.addArrangedSubview(participant)
            participant.snp.makeConstraints {
                $0.width.equalTo(90)
                $0.height.equalTo(130)
            }
        }
    }
    
    private func layoutConstraints() {
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        addSubview(infoStack)
        infoStack.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(studyInfo)
        studyInfo.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(frame.width * 0.8)
            $0.height.equalTo(25)
        }
        
        addSubview(languageTitle)
        languageTitle.snp.makeConstraints {
            $0.top.equalTo(studyInfo.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        
        addSubview(languageStack)
        languageStack.snp.makeConstraints {
            $0.top.equalTo(languageTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addSubview(participantTitle)
        participantTitle.snp.makeConstraints {
            $0.top.equalTo(languageStack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(65)
            $0.height.equalTo(30)
        }
        
        addSubview(participantStack)
        participantStack.snp.makeConstraints {
            $0.top.equalTo(participantTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
        }
    }
}
