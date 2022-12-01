//
//  SelectStudySortViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class SelectStudySortViewController: ViewController {
    
    enum Constant {
        static let cellHeight = 40.0
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "정렬"
        $0.textAlignment = .center
    }
    
    private let sortCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()).then {
            let layout = UICollectionViewFlowLayout()
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = CGSize(width: 60.0, height: Constant.cellHeight)
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            $0.collectionViewLayout = layout
            $0.register(StudySortCell.self, forCellWithReuseIdentifier: StudySortCell.identifier)
            $0.showsHorizontalScrollIndicator = false
            $0.bounces = false
            layout.scrollDirection = .horizontal
            $0.isPagingEnabled = false
    }
    
    private let bag = DisposeBag()
    private let viewModel: SelectStudySortViewModel
    
    // MARK: - Inits
    
    init(viewModel: SelectStudySortViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = SelectStudySortViewModel.Input(
            selectedStudySort: sortCollectionView.rx.modelSelected(StudySort.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.studySorts
            .drive(sortCollectionView.rx.items) { collectionView, index, studySort in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StudySortCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? StudySortCell else {
                        return UICollectionViewCell()
                    }
                cell.configure(studySort: studySort)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutTitleLabel()
        layoutSortCollectionView()
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(32.0)
        }
    }
    
    private func layoutSortCollectionView() {
        view.addSubview(sortCollectionView)
        sortCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(Constant.cellHeight)
        }
    }
}
