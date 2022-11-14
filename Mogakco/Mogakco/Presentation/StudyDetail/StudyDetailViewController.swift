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

final class StudyDetailViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentsView = UIView()
    private lazy var studyTitleLabel = StudyTitleLabel(title: "스터디")
    private let dateView = StudyInfoView(
        image: UIImage(systemName: "calendar"),
        text: "1월 20일 12시 30분"
    )
    private let participantsView = StudyInfoView(
        image: UIImage(systemName: "person.2"),
        text: "2/3 참여"
    )
    private let locationView = StudyInfoView(
        image: UIImage(systemName: "scope"),
        text: "서울특별시 강남구 가페 어딘가"
    )
    private lazy var studyInfoStackView = UIStackView(
        arrangedSubviews: [dateView, participantsView, locationView]
    ).then {
        $0.spacing = 5
        $0.alignment = .fill
        $0.axis = .vertical
    }
    
    private lazy var studyIntroduceLabel = StudyTitleLabel(title: "스터디 소개")
    private lazy var studyInfoDescription = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = .mogakcoFont.mediumRegular
        $0.text = "모바일에 관심 있으신 분들 함께해요~!"
    }
    
    private lazy var laguageLabel = StudyTitleLabel(title: "언어")
    private lazy var languageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var participantsInfoLabel = StudyTitleLabel(title: "참여중인 사람 2/3")
    private lazy var participantsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    // TODO: 커스텀 버튼으로 변경 필요
    private lazy var studyJoinButton = UIButton().then {
        $0.backgroundColor = .mogakcoColor.primaryDefault
        $0.tintColor = .mogakcoColor.typographyPrimary
        $0.setTitle("스터디 참여", for: .normal)
    }
    
    var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    private func layout() {
        layoutSubViews()
        layoutConstraints()
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
            participantsCollectionView,
            studyJoinButton
        ])
    }
    
    private func layoutConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view)
        }
        
        studyTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        studyInfoStackView.snp.makeConstraints {
            $0.top.equalTo(studyTitleLabel.snp.bottom) .offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        studyIntroduceLabel.snp.makeConstraints {
            $0.top.equalTo(studyInfoStackView.snp.bottom) .offset(15)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        studyInfoDescription.snp.makeConstraints {
            $0.top.equalTo(studyIntroduceLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        laguageLabel.snp.makeConstraints {
            $0.top.equalTo(studyInfoDescription.snp.bottom) .offset(15)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        languageCollectionView.snp.makeConstraints {
            $0.top.equalTo(laguageLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        participantsInfoLabel.snp.makeConstraints {
            $0.top.equalTo(languageCollectionView.snp.bottom) .offset(15)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        participantsCollectionView.snp.makeConstraints {
            $0.top.equalTo(participantsInfoLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(100)
        }
        
        studyJoinButton.snp.makeConstraints {
            $0.top.equalTo(participantsCollectionView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
}
