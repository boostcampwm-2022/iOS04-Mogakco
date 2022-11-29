//
//  SelectStudySortViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxCocoa
import RxSwift

final class SelectStudySortViewModel: ViewModel {
    
    struct Input {
        let selectedStudySort: Observable<StudySort>
    }
    
    struct Output {
        let studySorts: Driver<[StudySort]>
    }
    
    private weak var coordinator: StudyTabCoordinatorProtocol?
    private let studySortObserver: AnyObserver<StudySort>
    var disposeBag = DisposeBag()
    
    init(
        studySortObserver: AnyObserver<StudySort>,
        coordinator: StudyTabCoordinatorProtocol
    ) {
        self.studySortObserver = studySortObserver
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.selectedStudySort
            .withUnretained(self)
            .subscribe(onNext: { viewModel, studySort in
                viewModel.studySortObserver.onNext(studySort)
                // TODO: dismiss
            })
            .disposed(by: disposeBag)
        
        return Output(
            studySorts: Driver.just(StudySort.allCases)
        )
    }
}
