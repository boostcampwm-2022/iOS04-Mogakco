//
//  StudyListViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class StudyListViewController: ViewController {
    
    private let header = StudyListHeader()
    
    private lazy var refreshControl = UIRefreshControl().then {
        $0.tintColor = .white
    }
    
    private lazy var skeletonContentsView = StudyListSkeletonContentsView()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout()
    ).then {
        $0.refreshControl = refreshControl
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(StudyCell.self, forCellWithReuseIdentifier: StudyCell.identifier)
    }
    
    private let viewModel: StudyListViewModel
    
    // MARK: - Inits
    
    init(viewModel: StudyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        
        let input = StudyListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in () }.asObservable(),
            plusButtonTapped: header.plusButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            cellSelected: collectionView.rx.itemSelected
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            refresh: refreshControl.rx.controlEvent(.valueChanged)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            sortButtonTapped: header.sortButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            languageButtonTapped: header.languageButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            categoryButtonTapped: header.categoryButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            resetButtonTapped: header.resetButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)

        output.studyList
            .drive(self.collectionView.rx.items(
                cellIdentifier: StudyCell.identifier,
                cellType: StudyCell.self
            )) { _, study, cell in
                cell.setup(study)
            }
            .disposed(by: disposeBag)
        
        output.isLoading
            .subscribe(onNext: { [weak self] isHidden in
                self?.collectionView.isHidden = isHidden
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .bind(to: skeletonContentsView.rx.skeleton)
            .disposed(by: disposeBag)

        output.sortSelected
            .drive(onNext: { [weak self] in
                self?.header.sortButton.isSelected = $0
                self?.header.attributeButtonBorderColor(button: self?.header.sortButton)
            })
            .disposed(by: disposeBag)
        
        output.languageSelected
            .drive(onNext: { [weak self] in
                self?.header.languageButton.isSelected = $0
                self?.header.attributeButtonBorderColor(button: self?.header.languageButton)
            })
            .disposed(by: disposeBag)
        
        output.categorySelected
            .drive(onNext: { [weak self] in
                self?.header.categoryButton.isSelected = $0
                self?.header.attributeButtonBorderColor(button: self?.header.categoryButton)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        skeletonContentsView.clipsToBounds = true
        
        view.addSubview(skeletonContentsView)
        skeletonContentsView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(header.snp.bottom).offset(16)
        }
        
        skeletonContentsView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = .init(top: 1, leading: 16, bottom: 16, trailing: 16)
            return section
        }
    }
}
