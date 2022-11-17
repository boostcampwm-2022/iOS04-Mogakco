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
    
    private let hashtagListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.allowsMultipleSelection = true
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
    
    // MARK: - Property
    
    var viewModel: HashtagSelectViewModel
    
    // MARK: - function
    
    init(viewModel: HashtagSelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewController(
        navigaionTitle: String,
        descriptionTitle: String,
        secondaryDescriptionTitle: String
    ) {
        navigationItem.title = navigaionTitle
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
        let output = viewModel.transform(input: HashtagSelectViewModel.Input())

        output.collectionReloadObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.hashtagListCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
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
        guard let count = try? viewModel.badgeList.value().count else { return 0 }
        return count
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
        
        let cellTitle = try? viewModel.badgeList.value()[indexPath.row]
        if viewModel.isSelected(title: cellTitle) {
            cell.select()
        }
        cell.setInfo(iconName: cellTitle, title: cellTitle)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BadgeCell,
            let title = cell.titleLabel.text else { return }
        viewModel.selectBadge(title: title)
        cell.select()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BadgeCell,
            let title = cell.titleLabel.text else { return }
        viewModel.deselectBadge(title: title)
        cell.deselect()
    }
}

extension HashtagSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let title = viewModel.cellTitle(index: indexPath.row)
        
        return CGSize(
            width: title.size(
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
