//
//  LeaveStudyUseCase.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct LeaveStudyUseCase: LeaveStudyUseCaseProtocol {
    let studyRepository: StudyRepositoryProtocol
    
    var disposeBag = DisposeBag()
    
    init(
        studyRepository: StudyRepositoryProtocol
    ) {
        self.studyRepository = studyRepository
    }
    
    func leaveStudy(id: String) -> Observable<Void> {
        return studyRepository.leaveStudy(id: id)
    }
}
