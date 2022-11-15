//
//  SetPasswordViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class SetPasswordViewController: UIViewController { // TODO: UIViewController -> ViewController
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        keyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = Constant.navigationTitle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func bind() { }
    
    func layout() {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }
    
    func keyboardEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.button.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.button.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            }
            self.view.layoutIfNeeded()
        }
    }
}
