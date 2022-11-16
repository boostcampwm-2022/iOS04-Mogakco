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
    
    private let viewModel: SetPasswordViewModel
    
    enum Constant {
        static let navigationTitle = "회원가입"
        static let title = "안전한 계정을 위한\n비밀번호를 설정해주세요"
        static let password = "비밀번호를 입력해주세요"
        static let passwordCheck = "비밀번호 재입력"
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
        $0.spacing = 8
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
    
    // MARK: - Inits
    
    init(viewModel: SetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = Constant.navigationTitle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    override func bind() {
        
        let input = SetPasswordViewModel.Input(
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            passwordCheck: passwordCheckTextField.rx.text.orEmpty.asObservable(),
            nextButtonTapped: button.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.passwordState
            .subscribe(onNext: { [weak self] in
                let state: TextField.Validation = $0 ? .valid : .invalid
                self?.passwordTextField.validation = state
            })
            .disposed(by: disposeBag)
        
        output.passwordCheckState
            .subscribe(onNext: { [weak self] in
                let state: TextField.Validation = $0 ? .valid : .invalid
                self?.passwordCheckTextField.validation = state
            })
            .disposed(by: disposeBag)
        
        output.nextButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.button.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.button.snp.remakeConstraints {
                    $0.height.equalTo(52)
                    $0.left.right.equalToSuperview().inset(16)
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardVisibleHeight)
                }
                UIView.animate(withDuration: 1) {
                    self.view.layoutIfNeeded()
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
            $0.height.equalTo(52)
        }
    }
}
