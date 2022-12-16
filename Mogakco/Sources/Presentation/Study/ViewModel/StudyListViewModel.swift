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
    case sort(observer: AnyObserver<StudySort>)
    case languageFilter(hashtags: [Hashtag], observer: AnyObserver<[Hashtag]>)
    case categoryFilter(hashtags: [Hashtag], observer: AnyObserver<[Hashtag]>)
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
        let isLoading: Observable<Bool>
        let sortSelected: Driver<Bool>
        let languageSelected: Driver<Bool>
        let categorySelected: Driver<Bool>
    }
    
    let navigation = PublishSubject<StudyListNavigation>()
    var studyListUseCase: StudyListUseCaseProtocol?
    var disposeBag = DisposeBag()
    private let studyList = PublishSubject<[Study]>()
    private let isLoading = BehaviorSubject(value: true)
    private let filters = BehaviorSubject<[StudyFilter]>(value: [])
    private let refresh = PublishSubject<Int>()
    private let sort = BehaviorSubject<StudySort>(value: .latest)
    private let languageFilter = BehaviorSubject<[Hashtag]>(value: [])
    private let categoryFilter = BehaviorSubject<[Hashtag]>(value: [])

    func transform(input: Input) -> Output {
        bindRefresh(input: input)
        bindFilterSort(input: input)
        bindScene(input: input)
        return Output(
            studyList: studyList.asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asObservable(),
            sortSelected: sort.map { $0 != .latest }.asDriver(onErrorJustReturn: false),
            languageSelected: languageFilter.map { !$0.isEmpty }.asDriver(onErrorJustReturn: false),
            categorySelected: categoryFilter.map { !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        )
    }
    
    func bindRefresh(input: Input) {
        refresh
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(sort, filters)) { ($0, $1) }
            .flatMap { [weak self] delay, arguments -> Observable<Result<[Study], Error>> in
                let (sort, filters) = arguments
                return Observable.combineLatest(
                    Observable.just(()).delay(
                        .seconds(delay),
                        scheduler: MainScheduler.instance
                    ),
                    self?.studyListUseCase?.list(
                        sort: sort,
                        filters: filters
                    )
                    .asResult() ?? .empty()
                ) { $1 }
            }
            .do { [weak self] _ in self?.isLoading.onNext(false) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let list):
                    self?.studyList.onNext(list)
                case .failure:
                    self?.studyList.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(3)
            .withUnretained(self)
            .subscribe { $0.0.refresh.onNext($0.1) }
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                input.viewWillAppear.skip(1),
                input.refresh
            )
            .map { _ in return 0 }
            .bind(to: refresh)
            .disposed(by: disposeBag)
    }
    
    func bindFilterSort(input: Input) {
        Observable.combineLatest(sort.skip(1), filters.skip(1))
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { _ in return 0 }
            .withUnretained(self)
            .subscribe(onNext: { $0.0.refresh.onNext($0.1) })
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
                var filters = [StudyFilter.languages(language.map { $0.id })]
                if let category = category.first {
                    filters.append(StudyFilter.category(category.id))
                }
                return filters
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
            .map { .detail(id: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.plusButtonTapped
            .map { .create }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .map { viewModel, _ in
                return StudyListNavigation.languageFilter(
                    hashtags: (try? viewModel.languageFilter.value()) ?? [],
                    observer: viewModel.languageFilter.asObserver()
                )
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.categoryButtonTapped
            .withUnretained(self)
            .map { viewModel, _ in
                return StudyListNavigation.categoryFilter(
                    hashtags: (try? viewModel.categoryFilter.value()) ?? [],
                    observer: viewModel.categoryFilter.asObserver()
                )
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.sortButtonTapped
            .withUnretained(self)
            .map { viewModel, _ in
                return StudyListNavigation.sort(
                    observer: viewModel.sort.asObserver()
                )
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
