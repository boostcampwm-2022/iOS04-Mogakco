//
//  ProfileViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

final class ProfileViewController: UIViewController {

    enum Constant {
        static let headerViewTitle = "프로필"
        static let languageHashtagListViewTitle = "언어"
        static let careerHashtagListViewTitle = "경력"
        static let categoryHashtagListViewTitle = "카테고리"
        static let headerViewHeight = 68.0
        static let profileViewHeight = 200.0
        static let hashtagViewHeight = 80.0
        static let studyRatingListView = 230.0
        static let bottomMarginViewHeight = 60.0
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        self.profileView,
        self.boundaryView,
        self.languageListView,
        self.careerListView,
        self.categoryListView,
        self.studyRatingListView,
        self.bottomMarginView
    ]).then {
        $0.spacing = 8.0
        $0.axis = .vertical
        $0.setCustomSpacing(12.0, after: self.boundaryView)
    }
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle(Constant.headerViewTitle)
    }
    
    private let profileView = ProfileView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.profileViewHeight)
        }
    }
    
    private let boundaryView = UIView().then {
        $0.backgroundColor = .mogakcoColor.primaryDefault
        $0.snp.makeConstraints {
            $0.height.equalTo(4.0) 
        }
    }
    
    private let languageListView = HashtagListView().then {
        $0.titleLabel.text = Constant.languageHashtagListViewTitle
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let careerListView = HashtagListView().then {
        $0.titleLabel.text = Constant.careerHashtagListViewTitle
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let categoryListView = HashtagListView().then {
        $0.titleLabel.text = Constant.categoryHashtagListViewTitle
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let studyRatingListView = StudyRatingListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingListView)
        }
    }
    
    private let bottomMarginView = UIView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.bottomMarginViewHeight)
        }
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        $0.tintColor = .mogakcoColor.primaryDefault
    }

    private let report = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .mogakcoColor.backgroundDefault
        bind()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        let input = ProfileViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }.asObservable(),
            editProfileButtonTapped: profileView.editProfileButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            chatButtonTapped: profileView.chatButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            hashtagEditButtonTapped: Observable.merge(
                languageListView.editButton.rx.tap.map { _ in KindHashtag.language },
                careerListView.editButton.rx.tap.map { _ in KindHashtag.career },
                categoryListView.editButton.rx.tap.map { _ in KindHashtag.category }
            )
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            settingButtonTapped: settingButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            reportButtonTapped: report
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        let output = viewModel.transform(input: input)
        
        bindIsMyProfile(output: output)
        bindProfile(output: output)
        bindHashtags(output: output)
        bindReportButton()
    }
    
    func bindIsMyProfile(output: ProfileViewModel.Output) {
        output.isMyProfile
            .drive(profileView.chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .drive(profileView.reportButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .drive(profileView.editProfileButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .drive(languageListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .drive(careerListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .drive(categoryListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .drive(settingButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindProfile(output: ProfileViewModel.Output) {
        output.profileImageURL
            .drive(profileView.roundProfileImageView.rx.loadImage)
            .disposed(by: disposeBag)
        
        output.representativeLanguageImage
            .drive(profileView.roundLanguageImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.name
            .drive(profileView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.introduce
            .drive(profileView.introduceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindHashtags(output: ProfileViewModel.Output) {
        languageListView.bind(hashtags: output.languages)
        careerListView.bind(hashtags: output.careers)
        categoryListView.bind(hashtags: output.categorys)
        
        output.studyRatingList
            .drive(onNext: { [weak self] studyRatingList in
                self?.studyRatingListView.configure(studyRatingList: studyRatingList)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindReportButton() {
        profileView.reportButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.alert(
                    title: "차단하기",
                    message: "이 사용자가 작성한 채팅들이 보이지 않게 됩니다.",
                    actions: [
                        UIAlertAction.cancel(),
                        UIAlertAction.destructive(
                            title: "차단",
                            handler: { [weak self] _ in self?.report.onNext(()) }
                        )
                    ]
                )
            })
            .disposed(by: disposeBag)
    }
    
    func layout() {
        layoutHeaderView()
        layoutScrollView()
        layoutSettingButton()
    }
    
    private func layoutHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constant.headerViewHeight)
        }
    }
    
    private func layoutSettingButton() {
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.right.equalTo(headerView).inset(16)
        }
    }
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
