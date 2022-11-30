//
//  LoginViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LoginViewController: ViewController {
    
    private let animationView = AnimationView()
    private let emailTextField = MessageTextField()
    private let secureTextField = SecureTextField()
    
    private let signupButton = UIButton().then {
        $0.setTitle("아직 회원이 아니신가요?", for: .normal)
        $0.setTitleColor(.tintColor, for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallRegular
    }
    
    private let loginButton = ValidationButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.clipsToBounds = true
    }
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.invalidate()
    }
    
    override func bind() {
        let input = LoginViewModel.Input(
            email: emailTextField.rx.text.orEmpty.asObservable(),
            password: secureTextField.rx.text.orEmpty.asObservable(),
            signupButtonTap: signupButton.rx.tap.asObservable(),
            loginButtonTap: loginButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)
        
        output.presentError
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutAnimationView()
        layoutEmailTextField()
        layoutSecureTextField()
        layoutSignupButton()
        layoutLoginButton()
    }
    
    private func layoutAnimationView() {
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.snp.centerY).offset(40)
        }
    }
    
    private func layoutSecureTextField() {
        view.addSubview(secureTextField)
        
        secureTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(emailTextField.snp.bottom).offset(8)
        }
    }
    
    private func layoutSignupButton() {
        view.addSubview(signupButton)
        
        signupButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.top.equalTo(secureTextField.snp.bottom).offset(4)
        }
    }
    
    private func layoutLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}
