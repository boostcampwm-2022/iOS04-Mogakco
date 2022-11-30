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
        let studyList: Driver<[Study]>
        let refreshFinished: Signal<Void>
        let sortSelected: Driver<Bool>
        let languageSelected: Driver<Bool>
        let categorySelected: Driver<Bool>
    }
    
    private weak var coordinator: StudyTabCoordinatorProtocol?
    private let studyListUseCase: StudyListUseCaseProtocol
    private let studyList = PublishSubject<[Study]>()
    private let refreshFinished = PublishSubject<Void>()
    private let sort = BehaviorSubject<StudySort>(value: .latest)
    private let languageFilter = BehaviorSubject<[Hashtag]>(value: [])
    private let categoryFilter = BehaviorSubject<Hashtag?>(value: nil)
    private let filters = BehaviorSubject<[StudyFilter]>(value: [])
    private let refresh = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    init(
        coordinator: StudyTabCoordinatorProtocol,
        studyListUseCase: StudyListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.studyListUseCase = studyListUseCase
    }
    
    func transform(input: Input) -> Output {
        bindRefresh(input: input)
        bindFilterSort(input: input)
        bindScene(input: input)
        return Output(
            studyList: studyList.asDriver(onErrorJustReturn: []),
            refreshFinished: refreshFinished.asSignal(onErrorJustReturn: ()),
            sortSelected: sort.map { $0 != .latest }.asDriver(onErrorJustReturn: false),
            languageSelected: languageFilter.map { !$0.isEmpty }.asDriver(onErrorJustReturn: false),
            categorySelected: categoryFilter.map { $0 != nil }.asDriver(onErrorJustReturn: false)
        )
    }
    
    func bindRefresh(input: Input) {
        Observable.merge([input.viewWillAppear, input.refresh])
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.refresh.onNext(())
            })
            .disposed(by: disposeBag)
        
        refresh
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(sort, filters))
            .withUnretained(self)
            .flatMap { viewModel, arguments in
                let (sort, filters) = arguments
                return viewModel.studyListUseCase.list(sort: sort, filters: filters)
            }
            .do { _ in self.refreshFinished.onNext(()) }
            .bind(to: studyList)
            .disposed(by: disposeBag)
    }
    
    func bindFilterSort(input: Input) {
        sort
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.refresh.onNext(())
            })
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
                viewModel.categoryFilter.onNext(nil)
                viewModel.sort.onNext(.latest)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(languageFilter, categoryFilter)
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .map { language, category -> [StudyFilter] in
                var newFilter: [StudyFilter] = []
                newFilter.append(StudyFilter.languages(language.map { $0.id }))
                if let category {
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
            .withUnretained(self)
            .subscribe { viewModel, id in
                viewModel.coordinator?.showStudyDetail(id: id)
            }
            .disposed(by: disposeBag)
        
        input.plusButtonTapped
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.coordinator?.showStudyCreate()
            }
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showLanguageSelect(delegate: self)
            })
            .disposed(by: disposeBag)
        
        input.categoryButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showCategorySelect(delegate: self)
            })
            .disposed(by: disposeBag)
        
        input.sortButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showSelectStudySort(studySortObserver: viewModel.sort.asObserver())
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - HashtagSelectProtocol

extension StudyListViewModel: HashtagSelectProtocol {
    
    func selectedHashtag(kind: KindHashtag, hashTags: [Hashtag]) {
        print(hashTags.map { $0.title })
        switch kind {
        case .category:
            categoryFilter.onNext(hashTags.first)
        case .language:
            languageFilter.onNext(hashTags)
        default:
            break
        }
    }
}
