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
    
    struct Output { }
    
    private weak var coordinator: Coordinator?
    private let category = PublishSubject<String>()
    private let languages = PublishSubject<[String]>()
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        
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
        
        input.createButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.title,
                input.content,
                input.place,
                input.maxUserCount.map { Int($0) },
                input.date.map { $0.toInt(dateFormat: Format.compactDateFormat) },
                category,
                languages
            ))
            .withUnretained(self)
            .subscribe { _ in
                // TODO: 스터디 생성
                self.coordinator?.pop(animated: true)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
