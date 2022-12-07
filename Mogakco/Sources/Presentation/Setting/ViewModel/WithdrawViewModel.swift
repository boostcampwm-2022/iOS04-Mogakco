//
//  WithdrawViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum WithdrawNavigation {
    case success
    case back
}

final class WithdrawViewModel: ViewModel {
    
    struct Input {
        let backButtonDidTap: Observable<Void>
        let withdrawButtonDidTap: Observable<Void>
    }
    
    struct Output {
    }
    
    var disposeBag = DisposeBag()
    var withdrawUseCase: WithdrawUseCaseProtocol?
    var email: String?
    let navigation = PublishSubject<WithdrawNavigation>()
    
    func transform(input: Input) -> Output {
        let deleteInfo = PublishSubject<Void>()
        let deleteAuth = PublishSubject<Void>()
        
        input.backButtonDidTap
            .map { WithdrawNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.withdrawButtonDidTap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.withdrawUseCase?.delete()
                    .subscribe(deleteInfo)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        deleteInfo
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let email = self.email else { return }
                self.withdrawUseCase?.withdraw(email: email)
                    .subscribe(deleteAuth)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        deleteAuth
            .map { WithdrawNavigation.success }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output()
    }
}
