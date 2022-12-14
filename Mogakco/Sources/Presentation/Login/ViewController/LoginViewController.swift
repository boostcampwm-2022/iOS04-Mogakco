//
//  LoginViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import Then

final class LoginViewController: ViewController {
    
    enum Constant {
        static let padding: CGFloat = 40
    }
    
    private let logoView = LogoView()
    
    private let animationView = AnimationView(
        images: [
            UIImage(named: Language.swift.id),
            UIImage(named: Language.python.id),
            UIImage(named: Language.cpp.id),
            UIImage(named: Language.javaScript.id),
            UIImage(named: Language.ruby.id)
        ]
    )
    
    private let emailTextField = TextField()
    
    private let secureTextField = SecureTextField()
    
    private let loginButton = ValidationButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.clipsToBounds = true
        $0.snp.makeConstraints { make in
            make.height.equalTo(Layout.minimumButtonHeight)
        }
    }
    
    private let signupButton = UIButton().then {
        $0.setTitle("아직 회원이 아니신가요?", for: .normal)
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.titleLabel?.font = UIFont(name: SFPro.regular.rawValue, size: 13)
        $0.contentHorizontalAlignment = .leading
    }
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        emailTextField, secureTextField, createButtonStackView()
    ]).then {
        $0.alpha = 0
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .fill
    }
    
    private let viewModel: LoginViewModel
    
    // MARK: - Inits
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    override func bind() {
        let viewDidDisappear = rx.viewDidDisappear.map { _ in () }.asObservable()
        let didBackground = NotificationCenter.default
            .rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in () }
        
        Observable.merge(viewDidDisappear, didBackground)
            .subscribe(onNext: { [weak self] in
                self?.animationView.invalidate()
            })
            .disposed(by: disposeBag)
        
        let input = LoginViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }.asObservable(),
            email: emailTextField.rx.text.orEmpty.asObservable(),
            password: secureTextField.rx.text.orEmpty.asObservable(),
            signupButtonTap: signupButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            loginButtonTap: loginButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )

        let output = viewModel.transform(input: input)
        
        output.presentLogin
            .emit(onNext: { [weak self] in
                self?.animation()
            })
            .disposed(by: disposeBag)
        
        output.presentAlert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self else { return }
                self.updateContentViewLayout(height: keyboardVisibleHeight)
            })
            .disposed(by: disposeBag)
    }
    
    private func animation() {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            self?.contentView.alpha = 1
        }
    }
    
    override func layout() {
        layoutAnimationView()
        layoutLogo()
        layoutContentView()
    }
    
    private func layoutAnimationView() {
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutLogo() {
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints {
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(Constant.padding)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
        }
    }
    
    private func layoutContentView() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constant.padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
    }
    
    private func createButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [loginButton, signupButton]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
    }
    
    private func updateContentViewLayout(height: CGFloat) {
        let height = height == 0 ? 100 : height
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            self.contentView.snp.remakeConstraints {
                $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(Constant.padding)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-height)
            }
        }
    }
}
