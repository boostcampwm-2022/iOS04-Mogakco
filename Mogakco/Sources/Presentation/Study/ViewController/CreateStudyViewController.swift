//
//  CreateStudyViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CreateStudyViewController: ViewController {
    
    enum Constant {
        static let navigationTitle = "스터디 생성하기"
        static let textFieldHeight = Layout.textFieldHeight + 38
        static let textViewHeight = 120
        static let selectViewHeight = 40
        static let collectionViewHeight = 100
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = true
    }
    
    private let titleTextField = CountTextField().then {
        $0.title = "제목"
        $0.placeholder = "제목을 입력해주세요"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.textFieldHeight)
        }
    }
    
    private let contentTextView = CountTextView().then {
        $0.title = "내용"
        $0.placeholder = "내용을 입력해주세요"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.textViewHeight)
        }
    }
    
    private let placeTextField = CountTextField().then {
        $0.title = "지역"
        $0.placeholder = "지역을 입력해주세요"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.textFieldHeight)
        }
    }
    
    private let countStepper = StudyStepperView().then {
        $0.title = "인원"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.selectViewHeight)
        }
    }
    
    private let dateSelect = StudySelectView().then {
        $0.title = "날짜"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.selectViewHeight)
        }
    }
    
    private let categorySelect = StudySelectView().then {
        $0.title = "카테고리"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.selectViewHeight)
        }
    }
    
    private let languageSelect = StudySelectView().then {
        $0.title = "언어"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.selectViewHeight)
        }
    }
    
    private lazy var languageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout()
    ).then {
        $0.register(BadgeCell.self, forCellWithReuseIdentifier: BadgeCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.collectionViewHeight)
        }
    }
    
    private let createButton = ValidationButton().then {
        $0.setTitle(Constant.navigationTitle, for: .normal)
        $0.snp.makeConstraints {
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
    
    private let viewModel: CreateStudyViewModel
    
    // MARK: - Inits
    
    init(viewModel: CreateStudyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "새로운 스터디"
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func layout() {
        layoutCreateButton()
        layoutScrollView()
    }
    
    override func bind() {
        Observable.of(Array((0...0)))
            .bind(to: self.languageCollectionView.rx.items(
                cellIdentifier: BadgeCell.identifier,
                cellType: BadgeCell.self
            )) { _, badge, cell in

            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(createButton.snp.top).offset(-8)
        }
        
        let stackView = createTotalStackView()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func createTotalStackView() -> UIStackView {
        let subviews = [
            titleTextField,
            contentTextView,
            placeTextField,
            countStepper,
            dateSelect,
            categorySelect,
            createLanguageStackView()
        ]
        let stackView = UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        return stackView
    }
    
    private func createLanguageStackView() -> UIStackView {
        let subviews = [languageSelect, languageCollectionView]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
    }
    
    private func layoutCreateButton() {
        view.addSubview(createButton)
        createButton.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .estimated(50),
                    heightDimension: .absolute(30)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .estimated(50),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            group.interItemSpacing = .fixed(16)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            return section
        }
    }
}
