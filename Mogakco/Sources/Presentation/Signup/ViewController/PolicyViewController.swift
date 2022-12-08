//
//  PolicyViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import Then

final class PolicyViewController: ViewController {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "이용 약관 동의"
        $0.font = UIFont.mogakcoFont.title1Bold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "서비스 이용을 위한 약관에 동의해주세요."
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 16)
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let totalPolicy = PolicyCheckBox().then {
        $0.setup(body: "전체 약관에 동의합니다", type: .total)
    }
    
    private let servicePolicy = PolicyCheckBox().then {
        $0.setup(
            body: "서비스 이용 약관",
            type: .required,
            link: "https://complete-health-026.notion.site/28fa997c334b4442b4af9d87174df248"
        )
    }
    
    private let contentPolicy = PolicyCheckBox().then {
        $0.setup(
            body: "컨텐츠 이용 약관",
            type: .required,
            link: "https://complete-health-026.notion.site/93c1f73ed6414d78a7aaaeb4fe9446ad"
        )
    }
    
    private let button = ValidationButton().then {
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    private let viewModel: PolicyViewModel
    
    // MARK: - Inits
    
    init(viewModel: PolicyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "회원가입"
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        let input = PolicyViewModel.Input(
            totalPolicy: totalPolicy.checkButton.rx.isSelected,
            servicePolicy: servicePolicy.checkButton.rx.isSelected,
            contentPolicy: contentPolicy.checkButton.rx.isSelected,
            nextButtonTapped: button.rx.tap.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonEnabled
            .emit(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutStackViews()
        layoutButton()
    }
    
    private func layoutStackViews() {
        let header = createHeaderStackView()
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        let policy = createPolicyStackView()
        view.addSubview(policy)
        policy.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(header.snp.bottom).offset(30)
        }
    }
    
    private func layoutButton() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
    
    private func createHeaderStackView() -> UIStackView {
        let subviews = [titleLabel, subtitleLabel]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
    }
    
    private func createPolicyStackView() -> UIStackView {
        let subviews = [totalPolicy, servicePolicy, contentPolicy]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .vertical
            $0.spacing = 20
        }
    }
}
