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
        let sortButtonTapped: Observable<Void>
        let languageButtonTapped: Observable<Void>
        let categoryButtonTapped: Observable<Void>
        let resetButtonTapped: Observable<Void>
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
        let sort = BehaviorSubject<StudySort>(value: .latest)
        let languageFilter = BehaviorSubject<StudyFilter?>(value: nil)
        let categoryFilter = BehaviorSubject<StudyFilter?>(value: nil)
        let filters = BehaviorSubject<[StudyFilter]>(value: [])
        let reload = PublishSubject<Void>()

        Observable.merge([
            input.viewWillAppear,
            input.refresh,
            filters.skip(1).map { _ in () },
            sort.skip(1).map { _ in () }
        ])
            .withLatestFrom(Observable.combineLatest(sort, filters))
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { $0.0.useCase.list(sort: $0.1.0, filters: $0.1.1) }
            .do { _ in refreshFinished.onNext(()) }
            .subscribe(onNext: {
                studyList.onNext($0)
            })
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
        
        // 필터링
        input.languageButtonTapped
            .map { StudyFilter.languages(["python"]) }
            .subscribe(onNext: {
                languageFilter.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.categoryButtonTapped
            .map { StudyFilter.category("bigdata") }
            .subscribe(onNext: {
                categoryFilter.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.resetButtonTapped
            .subscribe(onNext: {
                languageFilter.onNext(nil)
                categoryFilter.onNext(nil)
                sort.onNext(.latest)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(languageFilter, categoryFilter)
            .map { [$0, $1].compactMap { $0 } }
            .subscribe(onNext: {
                filters.onNext($0)
            })
            .disposed(by: disposeBag)
        
        // 정렬
        input.sortButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showSelectStudySort(studySortObserver: sort.asObserver())
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            studyList: studyList,
            refreshFinished: refreshFinished
        )
    }
}
