//
//  PasswordCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum PasswrodCoordinatorResult {
    case finish(Bool)
    case back
}

final class PasswordCoordinator: BaseCoordinator<PasswrodCoordinatorResult> {
    
    let emailProps: EmailProps
    let finish = PublishSubject<PasswrodCoordinatorResult>()
    
    init(_ emailProps: EmailProps, _ navigationController: UINavigationController) {
        self.emailProps = emailProps
        super.init(navigationController)
    }
    
    override func start() -> Observable<PasswrodCoordinatorResult> {
        showPassword()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                case .back: self?.pop(animated: true)
                }
            })
    }
    
    // MARK: - 비밀번호
    
    func showPassword() {
        guard let viewModel = DIContainer.shared.container.resolve(SetPasswordViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .next(let password):
                    self?.showPolicy(password: password)
                case .back:
                    self?.finish.onNext(.back)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SetPasswordViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 이용 약관
    
    func showPolicy(password: String) {
        guard let viewModel = DIContainer.shared.container.resolve(PolicyViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .next:
                    self?.showProfile(password: password)
                case .back:
                    self?.pop(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = PolicyViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 프로필

    func showProfile(password: String) {
        let passwordProps = emailProps.toPasswordProps(password: password)
        let profile = SignupEditProfileCoordinator(passwordProps, navigationController)
        
        coordinate(to: profile)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish(let result):
                    self?.finish.onNext(.finish(result))
                case .back:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
