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
        let createButtonEnabled: Observable<Bool>
    }
    
    private weak var coordinator: Coordinator?
    private let useCase: CreateStudyUseCaseProtocol
    private let category = PublishSubject<String>()
    private let languages = PublishSubject<[String]>()
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator, useCase: CreateStudyUseCaseProtocol) {
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
                Study(
                    id: UUID().uuidString,
                    chatRoomID: "",
                    userIDs: [],
                    title: $0.0,
                    content: $0.1,
                    date: $0.2,
                    place: $0.3,
                    maxUserCount: $0.4,
                    languages: $0.5,
                    category: $0.6
                )
            }
        
        input.categoryButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { _ in
                // TODO: 카테고리 선택 화면 보여주기
            })
            .disposed(by: disposeBag)
        
        input.languageButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { _ in
                // TODO: 언어 선택 화면 보여주기
            })
            .disposed(by: disposeBag)
        
        input.date
            .subscribe { _ in
                // TODO: 테스트코드 - 삭제 예정
                self.category.onNext("iOS")
                self.languages.onNext(["swift"])
            }
            .disposed(by: disposeBag)
        
        input.createButtonTapped
            .withLatestFrom(study)
            .withUnretained(self)
            .flatMap { viewModel, study in
                viewModel.useCase.create(study: study)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.pop(animated: true)
            })
            .disposed(by: disposeBag)

        return Output(
            createButtonEnabled: study.map { _ in return true }
        )
    }
}
