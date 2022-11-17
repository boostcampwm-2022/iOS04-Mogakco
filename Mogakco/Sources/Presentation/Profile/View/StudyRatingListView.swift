//
//  StudyRatingListView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import UIKit

class StudyRatingListView: UIView {
    
    enum Constant {
        static let studyRatingViewHeight = 40.0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "스터디 참여 top3"
        $0.font = .mogakcoFont.mediumBold
        $0.textColor = .mogakcoColor.typographyPrimary
    }

    private let firstStudyRatingView = StudyRatingView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingViewHeight)
        }
    }
    
    private let secondStudyRatingView = StudyRatingView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingViewHeight)
        }
    }
    
    private let thirdStudyRatingView = StudyRatingView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingViewHeight)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let stackView = makeEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeEntireStackView() -> UIStackView {
        let arrangeViews = [titleLabel, firstStudyRatingView, secondStudyRatingView, thirdStudyRatingView]
        return UIStackView(arrangedSubviews: arrangeViews).then {
            $0.axis = .vertical
            $0.spacing = 4.0
            $0.layoutMargins = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}
