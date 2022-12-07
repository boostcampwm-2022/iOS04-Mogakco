//
//  StudyRatingView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import UIKit

class StudyRatingView: UIView {
    private let iconImageView = UIImageView()

    private let contentLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .left
    }

    private lazy var countLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .right
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient(
            startColor: .mogakcoColor.gradientStart?.withAlphaComponent(0.45) ?? .systemGray,
            endColor: .mogakcoColor.gradientEnd?.withAlphaComponent(0.45) ?? .systemGray,
            startPoint: .init(x: 0.0, y: 0.5),
            endPoint: .init(x: 1.0, y: 0.5)
        )
    }
    
    func configure(studyRating: (String, Int)) {
        iconImageView.image = UIImage(named: studyRating.0)
        contentLabel.text = studyRating.0
        countLabel.text = "+\(studyRating.1)"
    }

    private func attribute() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

    private func layout() {
        let stackView = createEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createEntireStackView() -> UIStackView {
        let arrangeSubviews = [iconImageView, contentLabel, countLabel]
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(iconImageView.snp.height)
        }
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = .init(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
            $0.axis = .horizontal
            $0.spacing = 12.0
        }
    }
}
