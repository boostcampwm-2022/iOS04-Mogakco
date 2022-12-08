//
//  WithdrawViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
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
        let presentAlert: Signal<Alert>
    }
    
    var disposeBag = DisposeBag()
    var withdrawUseCase: WithdrawUseCaseProtocol?
    let navigation = PublishSubject<WithdrawNavigation>()
    
    func transform(input: Input) -> Output {
        let deleteCompleted = PublishSubject<Void>()
        let withdrawCompleted = PublishSubject<Void>()
        let presentAlert = PublishSubject<Alert>()
        
        input.backButtonDidTap
            .map { WithdrawNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.withdrawButtonDidTap
            .withUnretained(self)
            .flatMap { $0.0.withdrawUseCase?.excute().asResult() ?? .empty() }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    withdrawCompleted.onNext(())
                case .failure:
                    let alert = Alert(title: "유저 정보 제거 오류", message: "유저 정보 제거 중 오류가 발생했어요", observer: nil)
                    presentAlert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)

        withdrawCompleted
            .map { WithdrawNavigation.success }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            presentAlert: presentAlert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
