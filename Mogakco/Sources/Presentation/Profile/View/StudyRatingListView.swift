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
        static let studyRatingListTitle = "스터디 참여 Top3"
        static let emptyText = "아직 참여한 스터디가 없어요"
        static let studyRatingViewHeight = 50.0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = Constant.studyRatingListTitle
        $0.font = .mogakcoFont.mediumBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingViewHeight)
        }
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
    
    private let emptyLabel = UILabel().then {
        $0.text = Constant.emptyText
        $0.font = .mogakcoFont.caption
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .center
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
    
    func configure(studyRatingList: [(String, Int)]) {
        let studyRatingViews = [firstStudyRatingView, secondStudyRatingView, thirdStudyRatingView]
        zip(studyRatingList, studyRatingViews).forEach { studyRating, studyRatingView in
            studyRatingView.configure(studyRating: studyRating)
        }
        firstStudyRatingView.isHidden = studyRatingList.count < 1
        secondStudyRatingView.isHidden = studyRatingList.count < 2
        thirdStudyRatingView.isHidden = studyRatingList.count < 3
        emptyLabel.isHidden = !studyRatingList.isEmpty
    }

    private func layout() {
        let stackView = createEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createEntireStackView() -> UIStackView {
        let arrangeViews = [
            titleLabel,
            firstStudyRatingView,
            secondStudyRatingView,
            thirdStudyRatingView,
            emptyLabel,
            UIView()
        ]
        return UIStackView(arrangedSubviews: arrangeViews).then {
            $0.axis = .vertical
            $0.spacing = 4.0
            $0.layoutMargins = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}
