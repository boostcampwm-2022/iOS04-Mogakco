//
//  WithdrawViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WithdrawViewController: ViewController {
    
    enum Constant {
        static let title = "정말 떠나시는 건가요?\n한 번 더 생각해 보지 않으시겠어요?"
        static let body = "계정을 삭제하시려는 이유을 말씀해주세요. 제품 개선에 중요한 자료로 활용하겠습니다."
        static let withdrawButtonTitle = "탈퇴하기"
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = Constant.title
        $0.font = UIFont.mogakcoFont.largeBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let bodyLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = Constant.body
        $0.numberOfLines = 0
        $0.font = UIFont.mogakcoFont.mediumRegular
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 20
        $0.axis = .vertical
    }
    
    private let deleteInfoIssue = PolicyCheckBox().then {
        $0.setup(body: "개인정보 삭제 목적", type: .withdraw)
    }
    
    private let inconvenienceIssue = PolicyCheckBox().then {
        $0.setup(body: "이용이 불편하고 장애가 많아서", type: .withdraw)
    }
    
    private let otherSiteIssue = PolicyCheckBox().then {
        $0.setup(body: "다른 앱이 더 좋아서", type: .withdraw)
    }
    
    private let duplicateAccountIssue = PolicyCheckBox().then {
        $0.setup(body: "중복 계정이 있어서", type: .withdraw)
    }
    
    private let lowUsageIssue = PolicyCheckBox().then {
        $0.setup(body: "사용 빈도가 낮아서", type: .withdraw)
    }

    private let dissatisfactionIssue = PolicyCheckBox().then {
        $0.setup(body: "콘텐츠 불만이 있어서", type: .withdraw)
    }
    
    private let withdrawButton = ValidationButton().then {
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitle(Constant.withdrawButtonTitle, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    let viewModel: WithdrawViewModel?
    
    init(viewModel: WithdrawViewModel) {
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
        layoutTitleLabel()
        layoutBodyLabel()
        layoutStackView()
        layoutWithdrawButton()
    }
    
    override func bind() {
        let input = WithdrawViewModel.Input(
            backButtonDidTap: backButton.rx.tap.asObservable(),
            withdrawButtonDidTap: withdrawButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            deleteInfoIssueDidTap: deleteInfoIssue.checkButton.rx.isSelected.asObservable(),
            inconvenienceIssueDidTap: inconvenienceIssue.checkButton.rx.isSelected.asObservable(),
            otherSiteIssueDidTap: otherSiteIssue.checkButton.rx.isSelected.asObservable(),
            duplicateAccountIssueDidTap: duplicateAccountIssue.checkButton.rx.isSelected.asObservable(),
            lowUsageIssueDidTap: lowUsageIssue.checkButton.rx.isSelected.asObservable(),
            dissatisfactionIssueDidTap: dissatisfactionIssue.checkButton.rx.isSelected.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.isCheck
            .subscribe(onNext: { [weak self] in
                self?.withdrawButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
            
        output?.presentAlert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func layoutBodyLabel() {
        view.addSubview(bodyLabel)
        
        bodyLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
        }
    }
    
    private func layoutStackView() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(bodyLabel.snp.bottom).offset(80)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        [
            deleteInfoIssue,
            inconvenienceIssue,
            otherSiteIssue,
            duplicateAccountIssue,
            lowUsageIssue,
            dissatisfactionIssue
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func layoutWithdrawButton() {
        view.addSubview(withdrawButton)
        
        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(80)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}
