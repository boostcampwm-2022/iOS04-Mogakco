//
//  AppCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        super.init(UINavigationController())
    }
    
    private func setup(with window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .mogakcoColor.backgroundDefault
    }
    
    override func start() -> Observable<Void> {
        setup(with: window)
        showLogin()
        return Observable.never()
    }
    
    private func showLogin() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let login = LoginCoordinator(navigationController)
        coordinate(to: login)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.showTab()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showTab() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tab = TabCoordinator(navigationController)
        coordinate(to: tab)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.showLogin()
                }
            })
            .disposed(by: disposeBag)
    }
}
