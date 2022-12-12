//
//  SettingViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum SettingNavigation {
    case withdraw
    case logout
    case back
}

final class SettingViewModel: ViewModel {
    
    struct Input {
        let logoutDidTap: Observable<Void>
        let withdrawDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let alert: Signal<Alert>
    }
    
    var disposeBag = DisposeBag()
    var logoutUseCase: LogoutUseCaseProtocol?
    var email: String?
    let navigation = PublishSubject<SettingNavigation>()
    
    func transform(input: Input) -> Output {
        
        let logoutAlertHandler = PublishSubject<Bool>()
        let alert = input.logoutDidTap
            .map { Alert(title: "로그아웃", message: "로그아웃 하시겠어요?", observer: logoutAlertHandler.asObserver()) }
        
        logoutAlertHandler
            .filter { $0 }
            .withUnretained(self)
            .flatMap { $0.0.logoutUseCase?.logout() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.navigation.onNext(.logout)
            })
            .disposed(by: disposeBag)
        
        input.withdrawDidTap
            .map { SettingNavigation.withdraw }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .map { SettingNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
