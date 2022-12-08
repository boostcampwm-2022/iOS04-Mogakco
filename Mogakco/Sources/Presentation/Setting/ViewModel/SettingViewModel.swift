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
              .withUnretained(self)
              .flatMap { $0.0.logoutUseCase?.logout().asResult() ?? .empty() }
              .map { _ in SettingNavigation.logout }
              .withUnretained(self)
              .subscribe(onNext: {
                  $0.0.navigation.onNext($0.1)
              }, onError: {
                  print($0.localizedDescription)
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
        
        return Output()
    }
}
