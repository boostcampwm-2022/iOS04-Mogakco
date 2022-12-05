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
        let withdrawSuccess = PublishSubject<Void>()
        
        input.backButtonDidTap
            .map { WithdrawNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.withdrawButtonDidTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.withdrawUseCase?
                    .withdraw(email: self.email ?? "")
                    .subscribe(onNext: {
                        print("DEBUG : withdraw 실행")
                        withdrawSuccess.onNext(())
                    })
                    .disposed(by: self.disposeBag)
                
                self.withdrawUseCase?.delete()
                    .subscribe { _ in
                        print("DEBUG : 아이디 삭제")
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        withdrawSuccess
            .map { WithdrawNavigation.success }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output()
    }
}
