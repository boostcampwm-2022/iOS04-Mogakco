//
//  StudyListViewModel.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class StudyListViewModel: ViewModel {
   
    struct Input {
        let cellSelected: Observable<IndexPath>
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: StudyTabCoordinatorProtocol?
    private let useCase: StudyListUseCaseProtocol
    var disposeBag = DisposeBag()
    
    init(
        coordinator: StudyTabCoordinatorProtocol,
        useCase: StudyListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        
        input.cellSelected
            .withUnretained(self)
            .subscribe { _ in
                self.coordinator?.showStudyDetail()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
