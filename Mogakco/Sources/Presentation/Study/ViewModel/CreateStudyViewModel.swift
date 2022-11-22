//
//  CreateStudyViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class CreateStudyViewModel: ViewModel {
   
    struct Input {
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        
        input.createButtonTapped
            .withUnretained(self)
            .subscribe { _ in
                self.coordinator?.pop(animated: true)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
