//
//  SetPasswordViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import Then

final class SetPasswordViewController: ViewController {
    
    enum Constant {
        static let navigationTitle = "회원가입"
        static let title = "안전한 계정을 위한\n비밀번호를 설정해주세요"
        static let password = "영문, 숫자 조합 6자 이상"
        static let passwordCheck = "비밀번호 재입력"
        static let passwordValidMessage = "안전한 비밀번호입니다."
        static let passwordInvalidMessage = "영문, 숫자를 포함하여 총 6글자 이상이어야 합니다."
        static let passwordCheckInvalidMessage = "비밀번호가 일치하지 않습니다."
        static let buttonTitle = "다음"
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = Constant.title
        $0.setLineSpacing(spacing: 4)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let passwordTextField = MessageTextField(isSecure: true).then {
        $0.placeholder = Constant.password
    }
    
    private let passwordCheckTextField = MessageTextField(isSecure: true).then {
        $0.placeholder = Constant.passwordCheck
    }
    
    private let button = ValidationButton().then {
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitle(Constant.buttonTitle, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    private let viewModel: SetPasswordViewModel
    
    // MARK: - Inits
    
    init(viewModel: SetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = Constant.navigationTitle
        navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    override func bind() {
        
        let input = SetPasswordViewModel.Input(
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            passwordCheck: passwordCheckTextField.rx.text.orEmpty.asObservable(),
            nextButtonTapped: button.rx.tap.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)

        output.passwordState
            .map { $0 ? TextField.Validation.valid : TextField.Validation.invalid }
            .bind(to: passwordTextField.rx.validation)
            .disposed(by: disposeBag)
        
        output.passwordState
            .map { $0 ? Constant.passwordValidMessage : Constant.passwordInvalidMessage }
            .bind(to: passwordTextField.rx.message)
            .disposed(by: disposeBag)
        
        output.passwordCheckState
            .map { $0 ? TextField.Validation.valid : TextField.Validation.invalid }
            .bind(to: passwordCheckTextField.rx.validation)
            .disposed(by: disposeBag)
        
        output.passwordCheckState
            .map { $0 ? "" : Constant.passwordCheckInvalidMessage }
            .bind(to: passwordCheckTextField.rx.message)
            .disposed(by: disposeBag)
        
        output.nextButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self else { return }
                if keyboardVisibleHeight == 0 {
                    self.updateButtonLayout(height: self.view.safeAreaInsets.bottom)
                } else {
                    self.updateButtonLayout(height: keyboardVisibleHeight)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        layoutTitleLabel()
        layoutStackView()
        layoutButton()
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func layoutStackView() {
        [passwordTextField, passwordCheckTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
    }
    
    private func layoutButton() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateButtonLayout(height: CGFloat) {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            self.button.snp.remakeConstraints {
                $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(16)
                $0.bottom.equalToSuperview().inset(height + 16)
                $0.height.equalTo(Layout.buttonHeight)
            }
        }
    }
}
