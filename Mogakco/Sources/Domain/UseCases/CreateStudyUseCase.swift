//
//  CreateStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct CreateStudyUseCase: CreateStudyUseCaseProtocol {
    
    private let studyRepository: StudyRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(studyRepository: StudyRepositoryProtocol) {
        self.studyRepository = studyRepository
    }
    
    func create(study: Study) -> Observable<Study> {
        return studyRepository.create(study: study)
    }
}
