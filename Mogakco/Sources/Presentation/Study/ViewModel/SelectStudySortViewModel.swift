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
    
    var sortObserver: AnyObserver<StudySort>?
    let finish = PublishSubject<Void>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.selectedStudySort
            .subscribe(onNext: { [weak self] in
                self?.sortObserver?.onNext($0)
                self?.finish.onNext(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            studySorts: Driver.just(StudySort.allCases)
        )
    }
}
