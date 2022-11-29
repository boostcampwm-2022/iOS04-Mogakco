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
        let viewWillAppear: Observable<Void>
        let plusButtonTapped: Observable<Void>
        let cellSelected: Observable<IndexPath>
        let refresh: Observable<Void>
    }
    
    struct Output {
        let studyList: Observable<[Study]>
        let refreshFinished: Observable<Void>
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
        
        let studyList = PublishSubject<[Study]>()
        let refreshFinished = PublishSubject<Void>()
        
        Observable.merge([input.viewWillAppear, input.refresh])
            .withUnretained(self)
            .flatMap { $0.0.useCase.list(sort: .latest, filters: []) }
            .do { _ in refreshFinished.onNext(()) }
            .bind(to: studyList)
            .disposed(by: disposeBag)
        
        input.plusButtonTapped
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.coordinator?.showStudyCreate()
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .withLatestFrom(
                Observable.combineLatest(
                    input.cellSelected,
                    studyList
                )
            )
            .map { $1[$0.row].id }
            .withUnretained(self)
            .subscribe { viewModel, id in
                viewModel.coordinator?.showStudyDetail(id: id)
            }
            .disposed(by: disposeBag)
        
        return Output(
            studyList: studyList,
            refreshFinished: refreshFinished
        )
    }
}
