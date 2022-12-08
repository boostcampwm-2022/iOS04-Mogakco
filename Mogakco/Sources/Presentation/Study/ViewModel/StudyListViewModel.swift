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

enum StudyListNavigation {
    case create
    case detail(id: String)
    case sort
    case languageFilter(filters: [Hashtag])
    case categoryFilter(filters: [Hashtag])
}

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
        let studyList: Driver<[Study]>
        let refreshFinished: Signal<Void>
        let sortSelected: Driver<Bool>
        let languageSelected: Driver<Bool>
        let categorySelected: Driver<Bool>
    }
    
    var studyListUseCase: StudyListUseCaseProtocol?
    private let studyList = PublishSubject<[Study]>()
    private let refreshFinished = PublishSubject<Void>()
    private let filters = BehaviorSubject<[StudyFilter]>(value: [])
    private let refresh = PublishSubject<Void>()
    let sort = BehaviorSubject<StudySort>(value: .latest)
    let languageFilter = BehaviorSubject<[Hashtag]>(value: [])
    let categoryFilter = BehaviorSubject<[Hashtag]>(value: [])
    let navigation = PublishSubject<StudyListNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        bindRefresh(input: input)
        bindFilterSort(input: input)
        bindScene(input: input)
        return Output(
            studyList: studyList.asDriver(onErrorJustReturn: []),
            refreshFinished: refreshFinished.asSignal(onErrorJustReturn: ()),
            sortSelected: sort.map { $0 != .latest }.asDriver(onErrorJustReturn: false),
            languageSelected: languageFilter.map { !$0.isEmpty }.asDriver(onErrorJustReturn: false),
            categorySelected: categoryFilter.map { !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        )
    }
    
    func bindRefresh(input: Input) {
        
        Observable.merge([input.viewWillAppear, input.refresh])
            .bind(to: refresh)
            .disposed(by: disposeBag)
        
        refresh
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .debounce(.microseconds(100), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(sort, filters))
            .withUnretained(self)
            .flatMap { viewModel, arguments -> Observable<Result<[Study], Error>> in
                let (sort, filters) = arguments
                return viewModel.studyListUseCase?.list(sort: sort, filters: filters).asResult() ?? .empty()
            }
            .do { _ in self.refreshFinished.onNext(()) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let studyList):
                    self?.studyList.onNext(studyList)
                case .failure:
                    self?.studyList.onNext([])
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindFilterSort(input: Input) {
        sort
            .skip(1)
            .map { _ in () }
            .bind(to: refresh)
            .disposed(by: disposeBag)
        
        filters
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.refresh.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.resetButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.languageFilter.onNext([])
                viewModel.categoryFilter.onNext([])
                viewModel.sort.onNext(.latest)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(languageFilter, categoryFilter)
            .map { language, category -> [StudyFilter] in
                var newFilter: [StudyFilter] = []
                newFilter.append(StudyFilter.languages(language.map { $0.id }))
                if let category = category.first {
                    newFilter.append(StudyFilter.category(category.id))
                }
                return newFilter
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, newFilters in
                viewModel.filters.onNext(newFilters)
            })
            .disposed(by: disposeBag)
    }
    
    func bindScene(input: Input) {
        input.cellSelected
            .withLatestFrom(Observable.combineLatest(input.cellSelected, studyList))
            .map { $1[$0.row].id }
            .map { StudyListNavigation.detail(id: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.plusButtonTapped
            .map { StudyListNavigation.create }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .compactMap { try? $0.0.languageFilter.value() }
            .map { StudyListNavigation.languageFilter(filters: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.categoryButtonTapped
            .withUnretained(self)
            .compactMap { try? $0.0.languageFilter.value() }
            .map { StudyListNavigation.categoryFilter(filters: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.sortButtonTapped
            .map { StudyListNavigation.sort }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
