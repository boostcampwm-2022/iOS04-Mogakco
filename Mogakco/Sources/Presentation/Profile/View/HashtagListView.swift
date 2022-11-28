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
    
    enum Constant {
        static let emtpyText = "편집 버튼을 눌러 나만의 해시태크를 설정해보세요"
        static let editButtonSize = CGSize(width: 45.0, height: 22.0)
    }
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    let editButton = UIButton().then {
        $0.addShadow(offset: .init(width: 5.0, height: 5.0))
        $0.layer.cornerRadius = 8.0
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.caption
        $0.setBackgroundColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.snp.makeConstraints {
            $0.size.equalTo(Constant.editButtonSize)
        }
    }

    let hashtagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)

        $0.collectionViewLayout = layout
        $0.register(HashtagBadgeCell.self, forCellWithReuseIdentifier: HashtagBadgeCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        layout.scrollDirection = .horizontal
        $0.isPagingEnabled = false
            $0.dataSource = nil
            $0.delegate = nil
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = Constant.emtpyText
        $0.font = .mogakcoFont.caption
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .center
    }
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(hashtags: Driver<[String]>) {
        hashtags
            .drive(hashtagCollectionView.rx.items) { collectionView, index, language in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BadgeCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? BadgeCell else {
                    return UICollectionViewCell()
                }
                cell.setInfo(iconName: language, title: language)
                return cell
            }
            .disposed(by: disposeBag)
        
        hashtags
            .map { !$0.isEmpty }
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        layoutEntireStackView()
        layoutEmtpyLabel()
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
    
    private func layoutEmtpyLabel() {
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.edges.equalTo(hashtagCollectionView)
        }
    }
}
