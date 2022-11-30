//
//  SignUpCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

// MARK: - AppCoordinator

final class MAppCoordinator: BaseCoordinator<Void> {
    
    init(_ window: UIWindow?) {
        super.init()
        setup(with: window)
    }
    
    private func setup(with window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    override func start() -> Observable<Void> {
        
        let authTrigger = PublishSubject<Void>()
        let mainTrigger = PublishSubject<Void>()
        
        authTrigger
            .debug()
            .withUnretained(self)
            .flatMap { $0.0.showAuth() }
            .subscribe(onNext: { result in
                switch result {
                case .finished:
                    mainTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        mainTrigger
            .withUnretained(self)
            .flatMap { $0.0.showMain() }
            .subscribe(onNext: { result in
                switch result {
                case .finished:
                    mainTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        authTrigger.onNext(())
        return Observable.empty()
    }
    
    /// Auth 플로우 (로그인/회원가입/자동로그인)
    private func showAuth() -> Observable<AuthCoordinatorResult> {
        let auth = MAuthCoordinator()
        return self.coordinator(to: auth)
    }
    
    /// Main 플로우 (스터디, 채팅, 프로필 등)
    private func showMain() -> Observable<MainCoordinatorResult> {
        let main = MMainCoordinator()
        return self.coordinator(to: main)
    }
}

// MARK: - Auth Coordinator

enum AuthCoordinatorResult {
    case finished
}

final class MAuthCoordinator: BaseCoordinator<AuthCoordinatorResult> {
    
    override func start() -> Observable<AuthCoordinatorResult> {
        return Observable.empty()
    }
    
    /// result: success / failure
    private func showLaunch() -> Observable<LaunchCoordinatorResult> {
        let launch = LaunchCoordinator()
        return self.coordinator(to: launch)
    }
    
    /// result: signup / login(Bool)
    private func showLogin() -> Observable<LoginCoordinatorResult> {
        let login = MLoginCoordinator()
        return self.coordinator(to: login)
    }
    
    /// result: success / failure
    private func showSingUp() {
    }
}

// MARK: - Launch Coordinator

enum LaunchCoordinatorResult {
    case success
    case failure
}

final class LaunchCoordinator: BaseCoordinator<LaunchCoordinatorResult> {
    
    override func start() -> Observable<LaunchCoordinatorResult> {
        
        let finish = PublishSubject<Bool>()
        
        let viewModel = LaunchScreenViewModel(
            autoLoginUseCase: AutoLoginUseCase(
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)),
                tokenRepository: TokenRepository(
                    keychainManager: KeychainManager(keychain: Keychain())
                )
            ),
            finishObserver: finish.asObserver()
        )
        let viewController = LaunchScreenViewController(viewModel: viewModel)
        push(viewController, animated: true)
        
        return finish
            .map { $0 ? LaunchCoordinatorResult.success : LaunchCoordinatorResult.failure }
    }
}

// MARK: - Login Coordinator

enum LoginCoordinatorResult {
    case singUp
    case login(Bool)
}

final class MLoginCoordinator: BaseCoordinator<LoginCoordinatorResult> {
    
    override func start() -> Observable<LoginCoordinatorResult> {
        
        let signUp = PublishSubject<Void>() /// 회원가입 요청 이벤트
        let login = PublishSubject<Bool>() /// 로그인 성공∙실패 이벤트
        let finish = PublishSubject<LoginCoordinatorResult>()
        
        let viewModel = LoginViewModel(
            loginUseCase: LoginUseCase(
                authRepository: AuthRepository(
                    authService: FBAuthService(provider: Provider.default)
                ),
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                ),
                tokenRepository: TokenRepository(
                    keychainManager: KeychainManager(keychain: Keychain()))
            ),
            signUpObserver: signUp.asObserver(),
            loginObserver: login.asObserver()
        )
        let viewController = LoginViewController(viewModel: viewModel)
        push(viewController, animated: true)
        
        signUp
            .subscribe { _ in finish.onNext(LoginCoordinatorResult.singUp) }
            .disposed(by: disposeBag)
        
        login
            .subscribe { finish.onNext(LoginCoordinatorResult.login($0)) }
            .disposed(by: disposeBag)
        
        return finish
    }
}

// MARK: - SignUp

enum SignUpCoordinatorResult {
    case success
    case failure
}

final class SignUpCoordinator: BaseCoordinator<SignUpCoordinatorResult> {
    
    // TODO: let emailProps = EmailProps(email: email)
    
    // TODO: let passwordProps = viewModel.emailProps.toPasswordProps(password: password)
    
    override func start() -> Observable<SignUpCoordinatorResult> {
        return Observable.empty()
    }
    
    func showEmail() -> Observable<EmailCoordinatorResult> {
        let email = EmailCoordinator()
        return self.coordinator(to: email)
    }
}

// MARK: - Email Coordiantor

enum EmailCoordinatorResult {
    case email(String)
}

final class EmailCoordinator: BaseCoordinator<EmailCoordinatorResult> {
    
    override func start() -> Observable<EmailCoordinatorResult> {
        let email = PublishSubject<String>()
        let viewModel = SetEmailViewModel(emailObserver: email.asObserver())
        let viewController = SetEmailViewController(viewModel: viewModel)
        push(viewController, animated: true)
        return email.map { EmailCoordinatorResult.email($0) }
    }
}

// MARK: - Password Coordinator

enum PasswrodCoordinatorResult {
    case password(String)
}

final class PasswordCoordinator: BaseCoordinator<PasswrodCoordinatorResult> {
    
    override func start() -> Observable<PasswrodCoordinatorResult> {
        let password = PublishSubject<String>()
        let viewModel = SetPasswordViewModel(passwordObserver: password.asObserver())
        let viewController = SetPasswordViewController(viewModel: viewModel)
        push(viewController, animated: true)
        return password.map { PasswrodCoordinatorResult.password($0) }
    }
}

// MARK: - Profile Coordinator

enum EditProfileCoordinatorResult {
    
}

final class EditProfileCoordinator: BaseCoordinator<EditProfileCoordinatorResult> {
    
    override func start() -> Observable<EditProfileCoordinatorResult> {
        
    }
}







// MARK: - Main Coordinator

enum MainCoordinatorResult {
    case finished
}

final class MMainCoordinator: BaseCoordinator<MainCoordinatorResult> {

    override func start() -> Observable<MainCoordinatorResult> {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .systemGreen
        navigationController.pushViewController(viewcontroller, animated: true)
//        return Observable.empty().delay(.seconds(2), scheduler: MainScheduler.instance)
        return Observable.never()
    }
}
