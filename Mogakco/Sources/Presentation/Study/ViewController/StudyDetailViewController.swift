//
//  StudyDetailViewController.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class StudyDetailViewController: ViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentsView = UIView()
    private lazy var studyTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "스터디"
    }
    private let dateView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "1월 20일 12시 30분"
        $0.imageView.image = UIImage(systemName: "calendar")
    }
    private let participantsView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "2/3 참여"
        $0.imageView.image = Image.profileDefault
    }
    
    private let locationView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "서울특별시 강남구 가페 어딘가"
        $0.imageView.image = UIImage(systemName: "scope")
    }
    
    private lazy var studyInfoStackView = UIStackView(
        arrangedSubviews: [dateView, participantsView, locationView]
    ).then {
        $0.spacing = 5
        $0.alignment = .fill
        $0.axis = .vertical
    }
    
    private lazy var studyIntroduceLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "스터디 소개"
    }
    private lazy var studyInfoDescription = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = .mogakcoFont.mediumRegular
        $0.text = """
        모바일에 관심 있으신 분들 함께해요~!
        모바일에 관심 있으신 분들 함께해요~!
        모바일에 관심 있으신 분들 함께해요~!
        모바일에 관심 있으신 분들 함께해요~!
        모바일에 관심 있으신 분들 함께해요~!
        """
    }
    
    private lazy var laguageLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "언어"
    }
    
    private let languageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: HashtagBadgeCell.addWidth, height: HashtagBadgeCell.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.collectionViewLayout = layout
        $0.register(HashtagBadgeCell.self, forCellWithReuseIdentifier: HashtagBadgeCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let participantsInfoLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "참여중인 사람 2/3"
    }
    
    private let participantsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(
            width: ParticipantCell.size.width,
            height: ParticipantCell.size.height
        )
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.collectionViewLayout = layout
        $0.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }

    private lazy var studyJoinButton = ValidationButton().then {
        $0.setTitle("스터디 참여", for: .normal)
    }
    
    // MARK: - Property
    
    var viewModel: StudyDetailViewModel
    var disposebag = DisposeBag()
    
    init(viewModel: StudyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func layout() {
        navigationLayout()
        layoutSubViews()
    }
    
    override func bind() {
        let input = StudyDetailViewModel.Input(
            studyJoinButtonTapped: studyJoinButton.rx.tap.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.studyDetail
            .subscribe(onNext: { [weak self] in
                self?.studyTitleLabel.text = $0.title
                self?.dateView.textLabel.text = $0.date.toCompactDateString()
                self?.participantsView.textLabel.text = "\($0.userIDs.count)/\($0.maxUserCount) 참여"
                self?.participantsInfoLabel.text = "\($0.userIDs.count)/\($0.maxUserCount) 참여"
                self?.locationView.textLabel.text = $0.place
                self?.studyInfoDescription.text = $0.content
            })
            .disposed(by: disposeBag)
        
        output.languages
            .drive(languageCollectionView.rx.items) { collectionView, index, hashtag in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HashtagBadgeCell.identifier,
                    for: IndexPath(row: index, section: 0)
                ) as? HashtagBadgeCell else {
                    return UICollectionViewCell()
                }
                cell.prepareForReuse()
                cell.setHashtag(hashtag: hashtag)
                
                return cell
            }
            .disposed(by: disposebag)
        
        output.participants
            .drive(participantsCollectionView.rx.items) { collectionView, index, user in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ParticipantCell.identifier,
                    for: IndexPath(row: index, section: 0)
                ) as? ParticipantCell else {
                    return UICollectionViewCell()
                }
                cell.prepareForReuse()
                cell.setInfo(user: user)
                
                return cell
            }
            .disposed(by: disposebag)
    }
    
    private func navigationLayout() {
        navigationItem.title = "스터디 제목"
        navigationItem.backButtonTitle = "이전"
        navigationItem.backBarButtonItem?.tintColor = .mogakcoColor.primaryDefault
    }
    
    private func layoutSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubViews([
            studyTitleLabel,
            studyInfoStackView,
            studyIntroduceLabel,
            studyInfoDescription,
            laguageLabel,
            languageCollectionView,
            participantsInfoLabel,
            participantsCollectionView
        ])
        
        layoutContentScroll()
        layoutStudyInfo()
        layoutStudyIntroduce()
        layoutLanguage()
        layoutParticipants()
        layoutStudyJoinButton()
    }
    
    private func layoutContentScroll() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view)
        }
    }
    
    private func layoutStudyInfo() {
        studyTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        studyInfoStackView.snp.makeConstraints {
            $0.top.equalTo(studyTitleLabel.snp.bottom) .offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func layoutStudyIntroduce() {
        studyIntroduceLabel.snp.makeConstraints {
            $0.top.equalTo(studyInfoStackView.snp.bottom) .offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        studyInfoDescription.snp.makeConstraints {
            $0.top.equalTo(studyIntroduceLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func layoutLanguage() {
        laguageLabel.snp.makeConstraints {
            $0.top.equalTo(studyInfoDescription.snp.bottom) .offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        languageCollectionView.snp.makeConstraints {
            $0.top.equalTo(laguageLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func layoutParticipants() {
        participantsInfoLabel.snp.makeConstraints {
            $0.top.equalTo(languageCollectionView.snp.bottom) .offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        participantsCollectionView.snp.makeConstraints {
            $0.top.equalTo(participantsInfoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }
    }
    
    private func layoutStudyJoinButton() {
        view.addSubview(studyJoinButton)
        studyJoinButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}
