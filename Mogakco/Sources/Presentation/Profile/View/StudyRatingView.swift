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
    private let iconImageView = UIImageView().then {
        $0.image = MogakcoAsset.algorithm.image
    }

    private let contentLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .left
        $0.text = "알고리즘 스터디"
    }

    private lazy var countLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .right
        $0.text = "+33"
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

    private func layout() {
        let stackView = makeEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeEntireStackView() -> UIStackView {
        let arrangeSubviews = [iconImageView, contentLabel, countLabel]
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(iconImageView.snp.height)
        }
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
    }
}
