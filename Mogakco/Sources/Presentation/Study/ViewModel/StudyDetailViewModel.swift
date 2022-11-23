//
//  StudyDetailViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class StudyDetailViewModel: ViewModel {
    
    struct Input {
        let studyJoinButtonTapped: Observable<Void>
    }
    
    struct Output {
        let studyDetail: Observable<Study>
        let languageReload: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let studyID: String
    private let coordinator: StudyTabCoordinatorProtocol
    private let studyUseCase: StudyDetailUseCaseProtocol
    private let hashtagUseCase: HashtagUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    var languages = BehaviorSubject<[Hashtag]>(value: [])
    var participants = BehaviorSubject<[User]>(value: [])
    
    var languageCount: Int {
        return (try? languages.value().count) ?? 0
    }
    
    var participantsCount: Int {
        return (try? participants.value().count) ?? 0
    }
    
    init(
        studyID: String,
        coordinator: StudyTabCoordinatorProtocol,
        studyUsecase: StudyDetailUseCaseProtocol,
        hashtagUseCase: HashtagUseCaseProtocol,
        userUseCase: UserUseCaseProtocol
    ) {
        self.studyID = studyID
        self.coordinator = coordinator
        self.studyUseCase = studyUsecase
        self.hashtagUseCase = hashtagUseCase
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        // TODO: 유저 UseCase에서 불러오기, 언어 불러오기 바인딩
        let reload = PublishSubject<Void>()
        let studyDetail = studyUseCase.study(id: studyID)
        
        studyDetail
            .withUnretained(self)
            .flatMap {
                return $0.0.hashtagUseCase.loadTagByString(kind: .language, tagTitle: $0.1.languages)
            }
            .subscribe(onNext: { [weak self] in
                self?.languages.onNext($0)
            })
            .disposed(by: disposeBag)
        
        languages
            .subscribe(onNext: { _ in
                reload.onNext(())
            })
            .disposed(by: disposeBag)
        
//        studyDetail
//            .withUnretained(self)
//            .flatMap {
//
//            }
//            .subscribe(onNext: { [weak self] in
//
//            })
//            .disposed(by: disposeBag)
        
        input.studyJoinButtonTapped
            .subscribe(onNext: {
                // TODO: 스터디 참가 API 바인딩 - studyUseCase -> JoinStudy()
                print("스터디 참가")
            })
            .disposed(by: disposeBag)
        
        return Output(
            studyDetail: studyDetail,
            languageReload: reload
        )
    }
    
    func languaegCellInfo(index: Int) -> Hashtag? {
        return try? languages.value()[index]
    }
}
