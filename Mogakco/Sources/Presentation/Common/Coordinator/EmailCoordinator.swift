//
//  EmailCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum EmailCoordinatorResult {
    case finish(Bool)
    case back
}

final class EmailCoordinator: BaseCoordinator<EmailCoordinatorResult> {
    
    let finish = PublishSubject<EmailCoordinatorResult>()
    
    override func start() -> Observable<EmailCoordinatorResult> {
        showEmail()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                case .back: self?.pop(animated: true)
                }
            })
    }
    
    // MARK: - 이메일
    
    func showEmail() {
        guard let viewModel = DIContainer.shared.container.resolve(SetEmailViewModel.self) else { return }

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .next(let email):
                    self?.showPassword(email: email)
                case .back:
                    self?.finish.onNext(.back)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SetEmailViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 비밀번호
    
    func showPassword(email: String) {
        let emailProps = EmailProps(email: email)
        let password = PasswordCoordinator(emailProps, navigationController)
        
        coordinate(to: password)
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
