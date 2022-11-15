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

final class WithdrawViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "정말 떠나시는 건가요?\n한 번 더 생각해 보지 않으시겠어요?"
        $0.font = UIFont.mogakcoFont.largeBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let bodyLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "계정을 삭제하시려는 이유을 말씀해주세요. 제품 개선에 중요한 자료로 활용하겠습니다."
        $0.numberOfLines = 0
        $0.font = UIFont.mogakcoFont.mediumRegular
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let passwordTitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "사용중인 비밀번호"
        $0.font = UIFont.mogakcoFont.caption
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 30
        $0.axis = .vertical
    }
    
    private let deleteInfoIssue = WithdrawReason.deleteInformation.checkBox
    private let inconvenienceIssue = WithdrawReason.inconvenience.checkBox
    private let otherSiteIssue = WithdrawReason.otherApp.checkBox
    private let duplicateAccountIssue = WithdrawReason.duplicateAccount.checkBox
    private let lowUsageIssue = WithdrawReason.lowUsage.checkBox
    private let dissatisfactionIssue = WithdrawReason.dissatisfaction.checkBox
    private let etcIssue = WithdrawReason.etc.checkBox
    
    private let secureTextField = SecureTextField()
    
    private let withdrawButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallRegular
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor.mogakcoColor.primaryDefault
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
    }
    
    func bind() {}
    
    private func layout() {
        layoutTitleLabel()
        layoutBodyLabel()
        layoutStackView()
        layoutCheckBoxs()
        layoutPasswordTitleLabel()
        layoutSecureTextFiled()
        layoutWithdrawButton()
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
    
    private func layoutCheckBoxs() {
        [deleteInfoIssue, inconvenienceIssue, otherSiteIssue,
         duplicateAccountIssue, lowUsageIssue, dissatisfactionIssue,
         etcIssue].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16)
            }
            
            stackView.addArrangedSubview($0)
        }
    }
    
    private func layoutStackView() {
        [deleteInfoIssue, inconvenienceIssue, otherSiteIssue,
         duplicateAccountIssue, lowUsageIssue, dissatisfactionIssue,
         etcIssue].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(bodyLabel.snp.bottom).offset(32)
        }
    }
    
    private func layoutPasswordTitleLabel() {
        view.addSubview(passwordTitleLabel)
        
        passwordTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(stackView.snp.bottom).offset(50)
        }
    }
    
    private func layoutSecureTextFiled() {
        view.addSubview(secureTextField)
        
        secureTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(16)
        }
    }
    
    private func layoutWithdrawButton() {
        view.addSubview(withdrawButton)
        
        withdrawButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.top.equalTo(secureTextField.snp.bottom).offset(16)
            $0.width.equalTo(120)
        }
    }
}
