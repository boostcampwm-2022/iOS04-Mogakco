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

enum CreateStudyNavigation {
    case language([Hashtag])
    case category([Hashtag])
    case back
}

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
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let category: Observable<Hashtag>
        let languages: Observable<[Hashtag]>
        let createButtonEnabled: Observable<Bool>
    }
    
    private let useCase: CreateStudyUseCaseProtocol
    let category = BehaviorSubject<[Hashtag]>(value: [])
    let languages = BehaviorSubject<[Hashtag]>(value: [])
    let navigation = PublishSubject<CreateStudyNavigation>()
    var disposeBag = DisposeBag()
    
    init(useCase: CreateStudyUseCaseProtocol) {
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
                category.asObservable().compactMap { $0.first }
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
            .compactMap { try? $0.0.category.value() }
            .map { CreateStudyNavigation.category($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .compactMap { try? $0.0.languages.value() }
            .map { CreateStudyNavigation.language($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.createButtonTapped
            .withLatestFrom(study)
            .withUnretained(self)
            .flatMap { viewModel, study in
                viewModel.useCase.create(study: study)
            }
            .map { _ in CreateStudyNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { CreateStudyNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            category: category.compactMap { $0.first },
            languages: languages,
            createButtonEnabled: study.map { _ in return true }
        )
    }
}
