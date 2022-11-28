//
//  ProfileViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

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
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        self.profileView,
        self.languageListView,
        self.careerListView,
        self.categoryListView,
        self.studyRatingListView,
        self.marginView
    ]).then {
        $0.spacing = 4.0
        $0.axis = .vertical
    }
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle(Constant.headerViewTitle)
    }
    
    private let profileView = ProfileView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.profileViewHeight)
        }
    }
    
    private let languageListView = HashtagListView().then {
        $0.titleLabel.text = "언어"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let careerListView = HashtagListView().then {
        $0.titleLabel.text = "경력"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let categoryListView = HashtagListView().then {
        $0.titleLabel.text = "카테고리"
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.hashtagViewHeight)
        }
    }
    
    private let studyRatingListView = StudyRatingListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(Constant.studyRatingListView)
        }
    }
    
    private let marginView = UIView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(200.0)
        }
    }
    
    private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    
    override func bind() {
        let input = ProfileViewModel.Input(
            editProfileButtonTapped: profileView.editProfileButton.rx.tap.asObservable(),
            chatButtonTapped: profileView.chatButton.rx.tap.asObservable(),
            hashtagEditButtonTapped: Observable.merge(
                languageListView.editButton.rx.tap.map { _ in KindHashtag.language },
                careerListView.editButton.rx.tap.map { _ in KindHashtag.career },
                categoryListView.editButton.rx.tap.map { _ in KindHashtag.category }
            )
        )
        let output = viewModel.transform(input: input)
        
        bindIsMyProfile(output: output)
        bindProfile(output: output)
        bindHashtags(output: output)
    }
    
    private func bindIsMyProfile(output: ProfileViewModel.Output) {
        output.isMyProfile
            .asDriver(onErrorJustReturn: false)
            .drive(profileView.chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(profileView.editProfileButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(languageListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(careerListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMyProfile
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(categoryListView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindProfile(output: ProfileViewModel.Output) {
        output.profileImageURL
            .asDriver(onErrorDriveWith: .empty())
            .drive(profileView.roundProfileImageView.rx.loadImage)
            .disposed(by: disposeBag)
        
        output.representativeLanguageImage
            .asDriver(onErrorJustReturn: .init())
            .drive(profileView.roundLanguageImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.name
            .asDriver(onErrorJustReturn: "")
            .drive(profileView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.introduce
            .asDriver(onErrorJustReturn: "")
            .drive(profileView.introduceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindHashtags(output: ProfileViewModel.Output) {
        output.languages
            .asDriver(onErrorJustReturn: [])
            .drive(languageListView.hashtagCollectionView.rx.items) { collectionView, index, language in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BadgeCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? BadgeCell else {
                    return UICollectionViewCell()
                }
                let hashtag = Languages.idToHashtag(id: language)
                cell.setHashtag(hashtag: hashtag)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.careers
            .asDriver(onErrorJustReturn: [])
            .drive(careerListView.hashtagCollectionView.rx.items) { collectionView, index, career in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BadgeCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? BadgeCell else {
                    return UICollectionViewCell()
                }
                let hashtag = Career.idToHashtag(id: career)
                cell.setHashtag(hashtag: hashtag)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.categorys
            .asDriver(onErrorJustReturn: [])
            .drive(categoryListView.hashtagCollectionView.rx.items) { collectionView, index, category in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BadgeCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? BadgeCell else {
                    return UICollectionViewCell()
                }
                let hashtag = Category.idToHashtag(id: category)
                cell.setHashtag(hashtag: hashtag)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.studyRatingList
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { viewController, studyRatingList in
                viewController.studyRatingListView.configure(studyRatingList: studyRatingList)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutHeaderView()
        layoutScrollView()
    }
    
    private func layoutHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constant.headerViewHeight)
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
