//
//  HashtagSelectViewController.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class HashtagSelectViewController: ViewController {
    
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = .mogakcoFont.mediumBold
        $0.text = "사용하시는 언어를 선택해주세요!"
    }
    private let secondaryTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographySecondary
        $0.font = .mogakcoFont.smallRegular
        $0.numberOfLines = 2
        $0.text = "다중 선택 가능(최대 5개)\n첫 번째 언어가 주 언어가 됩니다."
    }
    
    private let hashtagListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(BadgeCell.self, forCellWithReuseIdentifier: BadgeCell.identifier)
        $0.register(
            HashtagSelectHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HashtagSelectHeader.identifier
        )
    }
    
    private let nextButton = ValidationButton().then {
        $0.setTitle("선택 완료!", for: .normal)
    }
    
    // MARK: - function
    
    func setViewController(
        navigaionTitle: String,
        descriptionTitle: String,
        secondaryDescriptionTitle: String
    ) {
        navigationItem.title = navigaionTitle
        mainTitleLabel.text = descriptionTitle
        secondaryTitleLabel.text = secondaryDescriptionTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDelegate()
    }
    
    private func configDelegate() {
        hashtagListCollectionView.delegate = self
        hashtagListCollectionView.dataSource = self
    }
    
    override func bind() {
        //
    }
    
    override func layout() {
        layoutNavigation()
        layoutHashtagListCollectionView()
        layoutNextButton()
    }
    
    private func layoutNavigation() {
        navigationItem.title = "언어 선택"
        navigationItem.backButtonTitle = "이전"
        navigationItem.backBarButtonItem?.tintColor = .mogakcoColor.primaryDefault
    }
    
    private func layoutHashtagListCollectionView() {
        view.addSubview(hashtagListCollectionView)
        
        hashtagListCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - CollectionVIew

extension HashtagSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = hashtagListCollectionView.dequeueReusableCell(
            withReuseIdentifier: BadgeCell.identifier,
            for: indexPath) as? BadgeCell
        else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        
        if indexPath.row % 2 == 0 {
            cell.setInfo(iconImage: UIImage(named: "swift"), title: "Swift")
            return cell
        }
        
        cell.setInfo(iconImage: UIImage(named: "swift"), title: "javascript")
        
        return cell
    }
}

extension HashtagSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        if indexPath.row % 2 == 0 {
            return CGSize(
                width: "Swift".size(
                    withAttributes: [NSAttributedString.Key.font: UIFont.mogakcoFont.mediumRegular]
                ).width + BadgeCell.addWidth,
                height: BadgeCell.height
            )
        }
        
        return CGSize(
            width: "JavaScript".size(
                withAttributes: [NSAttributedString.Key.font: UIFont.mogakcoFont.mediumRegular]
            ).width + BadgeCell.addWidth,
            height: BadgeCell.height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = hashtagListCollectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: HashtagSelectHeader.identifier,
                  for: indexPath
              ) as? HashtagSelectHeader
        else { return UICollectionReusableView()}
        
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: HashtagSelectHeader.height)
    }
}
