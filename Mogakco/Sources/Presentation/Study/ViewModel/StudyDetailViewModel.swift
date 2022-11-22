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
        
        let studyDetail = studyUsecase.study(id: studyID).asObservable()
        
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
