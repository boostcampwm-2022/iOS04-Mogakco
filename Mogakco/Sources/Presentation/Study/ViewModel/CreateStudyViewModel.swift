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
        let title: Observable<String>
        let content: Observable<String>
        let place: Observable<String>
        let maxUserCount: Observable<Double>
        let date: Observable<Date>
        let categoryButtonTapped: Observable<Void>
        let languageButtonTapped: Observable<Void>
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        let category: Observable<Hashtag>
        let languages: Observable<[Hashtag]>
        let createButtonEnabled: Observable<Bool>
    }
    
    private weak var coordinator: StudyTabCoordinatorProtocol?
    private let useCase: CreateStudyUseCaseProtocol
    private let category = PublishSubject<Hashtag>()
    private let languages = PublishSubject<[Hashtag]>()
    var disposeBag = DisposeBag()
    
    init(
        coordinator: StudyTabCoordinatorProtocol,
        useCase: CreateStudyUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        
        let study = Observable
            .combineLatest(
                input.title,
                input.content,
                input.date.map { $0.toInt(dateFormat: Format.compactDateFormat) },
                input.place,
                input.maxUserCount.map { Int($0) },
                languages.asObservable(),
                category.asObservable()
            )
            .map {
                let id = UUID().uuidString
                return Study(
                    id: id,
                    chatRoomID: id,
                    userIDs: [],
                    title: $0.0,
                    content: $0.1,
                    date: $0.2,
                    place: $0.3,
                    maxUserCount: $0.4,
                    languages: $0.5.map { $0.id },
                    category: $0.6.id
                )
            }
        
        input.categoryButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showCategorySelect(delegate: self)
            })
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showLanguageSelect(delegate: self)
            })
            .disposed(by: disposeBag)

        input.createButtonTapped
            .withLatestFrom(study)
            .withUnretained(self)
            .flatMap { viewModel, study in
                viewModel.useCase.create(study: study)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.goToPrevScreen()
            })
            .disposed(by: disposeBag)

        return Output(
            category: category,
            languages: languages,
            createButtonEnabled: study.map { _ in return true }
        )
    }
}

// MARK: - HashtagSelectProtocol

extension CreateStudyViewModel: HashtagSelectProtocol {
    
    func selectedHashtag(kind: KindHashtag, hashTags: [Hashtag]) {
        switch kind {
        case .category:
            guard let selected = hashTags.first else { return }
            category.onNext(selected)
        case .language:
            languages.onNext(hashTags)
        default:
            break
        }
    }
}
