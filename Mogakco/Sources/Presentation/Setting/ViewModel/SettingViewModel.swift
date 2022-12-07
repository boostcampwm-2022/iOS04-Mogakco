//
//  SettingViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

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
    
    struct Output {}
    
    var disposeBag = DisposeBag()
    var logoutUseCase: LogoutUseCaseProtocol?
    var email: String?
    let navigation = PublishSubject<SettingNavigation>()
    
    func transform(input: Input) -> Output {
        
        input.logoutDidTap
            .map { _ in .logout }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.withdrawDidTap
            .map { _ in .withdraw }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .map { SettingNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output()
    }
}
