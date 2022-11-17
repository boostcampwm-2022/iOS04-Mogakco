//
//  CreateProfiileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class CreateProfiileViewModel: ViewModel {
    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let selectedProfileImage: Observable<UIImage>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let profileImage: Driver<UIImage>
    }
    
    var disposeBag = DisposeBag()
    weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        
        input.completeButtonTapped
            .withLatestFrom(Observable.combineLatest(input.name, input.introduce, input.selectedProfileImage))
            .subscribe(onNext: { _ in
                // TODO: UseCase - CreateProfile
                // TODO: AppDelegate - Push
                if let coordinator = self.coordinator as? AdditionalSignupCoordinator {
                    coordinator.showLanguage()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(profileImage: input.selectedProfileImage.asDriver(onErrorJustReturn: UIImage()))
    }
    
}
