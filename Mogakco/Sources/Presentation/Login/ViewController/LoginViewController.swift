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
    
    private let textFieldStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
    }
    
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
    
    private let contentView = UIView().then {
        $0.alpha = 0
    }
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.invalidate()
    }
    
    override func bind() {
        let input = LoginViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }.asObservable(),
            email: emailTextField.rx.text.orEmpty.asObservable(),
            password: secureTextField.rx.text.orEmpty.asObservable(),
            signupButtonTap: signupButton.rx.tap.asObservable(),
            loginButtonTap: loginButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)
        
        output.presentLogin
            .emit(onNext: { [weak self] in
                self?.animation()
            })
            .disposed(by: disposeBag)
        
        output.presentError
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    private func animation() {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            self?.contentView.alpha = 1
        }
    }
    
    override func layout() {
        layoutAnimationView()
        layoutContentView()
        layoutTextField()
        layoutSignupButton()
        layoutLoginButton()
    }
    
    private func layoutAnimationView() {
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutContentView() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
        }
    }
    
    private func layoutTextField() {
        let subviews = [emailTextField, secureTextField]
        subviews.forEach {
            textFieldStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(textFieldStackView)
        textFieldStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
    
    private func layoutSignupButton() {
        contentView.addSubview(signupButton)
        
        signupButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(4)
        }
    }
    
    private func layoutLoginButton() {
        contentView.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(100)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}
