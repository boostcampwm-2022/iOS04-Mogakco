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
        let alert: Signal<Alert>
    }
    
    var createStudyUseCase: CreateStudyUseCaseProtocol?
    let category = BehaviorSubject<[Hashtag]>(value: [])
    let languages = BehaviorSubject<[Hashtag]>(value: [])
    let navigation = PublishSubject<CreateStudyNavigation>()
    private let alert = PublishSubject<Alert>()
    var disposeBag = DisposeBag()

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
                viewModel.createStudyUseCase?.create(study: study).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.navigation.onNext(.back)
                case .failure:
                    let alert = Alert(title: "스터디 생성 오류", message: "스터디 생성 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { CreateStudyNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            category: category.compactMap { $0.first },
            languages: languages,
            createButtonEnabled: study.map { _ in return true },
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
