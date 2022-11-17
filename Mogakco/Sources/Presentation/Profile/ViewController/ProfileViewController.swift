//
//  ProfileViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class ProfileViewController: ViewController {

    enum Constant {
        static let headerViewTitle = "프로필"
        static let headerViewHeight = 68.0
        static let profileViewHeight = 200.0
        static let hashtagViewHeight = 100.0
        static let studyRatingListView = 200.0
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [self.headerView,
                                                                       self.profileView,
                                                                       self.languageListView,
                                                                       self.careerListView,
                                                                       self.categoryListView,
                                                                       self.studyRatingListView
                                                                      ]).then {
        $0.spacing = 4.0
        $0.axis = .vertical
    }
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle(Constant.headerViewTitle)
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.headerViewHeight)
        }
    }
    
    private let profileView = ProfileView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.profileViewHeight)
        }
    }
    
    private let languageListView = HashtagListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let careerListView = HashtagListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let categoryListView = HashtagListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let studyRatingListView = StudyRatingListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingListView)
        }
    }
    
    private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = ProfileViewModel.Input(
            editProfileButtonTapped: profileView.editProfileButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
    
    override func layout() {
        layoutScrollView()
    }
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
