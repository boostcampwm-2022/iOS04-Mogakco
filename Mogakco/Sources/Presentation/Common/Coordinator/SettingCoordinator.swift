//
//  SettingCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/12.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum SettingCoordinatorResult {
    case finish
    case back
}

final class SettingCoordinator: BaseCoordinator<SettingCoordinatorResult> {
    
    private let finish = PublishSubject<SettingCoordinatorResult>()
    
    override func start() -> Observable<SettingCoordinatorResult> {
        showSetting()
        return finish.do(onNext: { [weak self] _ in self?.popTabbar(animated: false) })
    }
    
    // MARK: - 설정화면
    
    func showSetting() {
        guard let viewModel = DIContainer.shared.container.resolve(SettingViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .withdraw:
                    self?.showWithdraw()
                case .logout:
                    self?.finish.onNext(.finish)
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SettingViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
    
    // MARK: - 회원탈퇴
    
    func showWithdraw() {
        guard let viewModel = DIContainer.shared.container.resolve(WithdrawViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .success:
                    self?.finish.onNext(.finish)
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = WithdrawViewController(viewModel: viewModel)
        pushTabbar(viewController, animated: true)
    }
}
