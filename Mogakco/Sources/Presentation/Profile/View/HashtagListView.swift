//
//  HashtagListView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class HashtagListView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallBold
        $0.text = "해시태크"
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    let editButton = UIButton().then {
        $0.addShadow(offset: .init(width: 5.0, height: 5.0))
        $0.layer.cornerRadius = 8.0
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallBold
        $0.setBackgroundColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.snp.makeConstraints {
            $0.width.equalTo(45.0)
            $0.height.equalTo(22.0)
        }
    }

    let hashtagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)

        $0.collectionViewLayout = layout
        $0.register(BadgeCell.self, forCellWithReuseIdentifier: BadgeCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        layout.scrollDirection = .horizontal
        $0.isPagingEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutEntireStackView()
    }
    
    private func layoutEntireStackView() {
        let stackView = createEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createEntireStackView() -> UIStackView {
        let arrangeSubviews = [createLabelStackView(), hashtagCollectionView]
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .vertical
            $0.spacing = 8.0
        }
    }
 
    private func createLabelStackView() -> UIStackView {
        let arrangeSubviews = [titleLabel, editButton]
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .horizontal
            $0.layoutMargins = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}
