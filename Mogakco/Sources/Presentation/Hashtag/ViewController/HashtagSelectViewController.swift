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

enum KindHashtag {
    case language
    case career
    case category
}

class HashtagSelectViewController: ViewController {
    
    lazy var hashtagListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HashtagFlowLayout(viewFrame: view.frame)
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.allowsMultipleSelection = true
        $0.register(HashtagBadgeCell.self, forCellWithReuseIdentifier: HashtagBadgeCell.identifier)
        $0.register(
            HashtagHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HashtagHeader.identifier
        )
    }
    
    private let nextButton = ValidationButton().then {
        $0.setTitle("선택 완료!", for: .normal)
    }
    
    // MARK: - Property
    
    private let viewModel: HashtagViewModel
    private let kind: KindHashtag
    private let cellSelect = PublishSubject<Int>()
    
    // MARK: - function
    
    init(kind: KindHashtag, viewModel: HashtagViewModel) {
        self.kind = kind
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configDelegate() {
        hashtagListCollectionView.delegate = self
        hashtagListCollectionView.dataSource = self
    }
    
    override func bind() {
        let input = HashtagViewModel.Input(
            kindHashtag: Observable.just(kind),
            cellSelected: cellSelect.asObservable(),
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)

        output.hashtagReload
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
        switch kind {
        case .language: navigationItem.title = "언어 선택"
        case .career: navigationItem.title = "경력 선택"
        case .category: navigationItem.title = "카테고리 선택"
        }
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
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}

// MARK: - CollectionVIew

extension HashtagSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionViewCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = hashtagListCollectionView.dequeueReusableCell(
            withReuseIdentifier: HashtagBadgeCell.identifier,
            for: indexPath) as? HashtagBadgeCell
        else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        
        let cellHashtag = viewModel.cellInfo(index: indexPath.row)
        if viewModel.isSelected(index: indexPath.row) {
            cell.select()
        }
        cell.setHashtag(hashtag: cellHashtag)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HashtagBadgeCell else { return }
        cellSelect.onNext(indexPath.row)
        cell.select()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HashtagBadgeCell else { return }
        cellSelect.onNext(indexPath.row)
        cell.deselect()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let selectedCount = collectionView.indexPathsForSelectedItems?.count else {
            return false }
        switch kind {
        case .language, .career: return selectedCount < 5
        case .category: return selectedCount < 1
        }
    }
}

extension HashtagSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let title = viewModel.cellInfo(index: indexPath.row)?.title else {
            return CGSize(width: HashtagBadgeCell.addWidth, height: HashtagBadgeCell.height)
        }
        
        return CGSize(
            width: title.size(
                withAttributes: [NSAttributedString.Key.font: UIFont.mogakcoFont.mediumRegular]
            ).width + HashtagBadgeCell.addWidth,
            height: HashtagBadgeCell.height
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
                  withReuseIdentifier: HashtagHeader.identifier,
                  for: indexPath
              ) as? HashtagHeader
        else { return UICollectionReusableView() }
        header.setTitle(kind: self.kind)
        return header
    }
}
