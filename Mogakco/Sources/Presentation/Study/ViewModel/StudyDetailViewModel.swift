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
    }
    
    private let studyID: String
    private let coordinator: StudyTabCoordinatorProtocol
    private let studyUsecase: StudyDetailUseCaseProtocol
    private var languages: [Hashtag] = []
    private var participants: [User] = []
    
    init(
        studyID: String,
        coordinator: StudyTabCoordinatorProtocol,
        studyUsecase: StudyDetailUseCaseProtocol
    ) {
        self.studyID = studyID
        self.coordinator = coordinator
        self.studyUsecase = studyUsecase
    }
    
    func transform(input: Input) -> Output {
        // TODO: 유저 UseCase에서 불러오기, 언어 불러오기 바인딩
        let languages = PublishSubject<[String]>()
        let users = PublishSubject<[String]>()
        
        let studyDetail = studyUsecase.study(id: studyID)
            .map {
                languages.onNext($0.languages)
                users.onNext($0.userIDs)
                return $0
            }
        
        input.studyJoinButtonTapped
            .subscribe(onNext: {
                // TODO: 스터디 참가 API 바인딩 - studyUseCase -> JoinStudy()
                print("스터디 참가")
            })
            .disposed(by: disposeBag)
        
        return Output(studyDetail: studyDetail)
    }
    
    var disposeBag = DisposeBag()
}
