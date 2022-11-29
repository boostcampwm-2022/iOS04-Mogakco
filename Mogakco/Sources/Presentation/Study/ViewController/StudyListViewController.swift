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
    
    private lazy var refreshControl = UIRefreshControl()
    
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
            plusButtonTapped: header.plusButton.rx.tap.asObservable(),
            cellSelected: collectionView.rx.itemSelected.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.studyList
            .bind(to: self.collectionView.rx.items(
                cellIdentifier: StudyCell.identifier,
                cellType: StudyCell.self
            )) { _, study, cell in
                cell.setup(study)
            }
            .disposed(by: disposeBag)
        
        output.refreshFinished
            .subscribe(onNext: { [weak self] in
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(header.snp.bottom).offset(16)
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
