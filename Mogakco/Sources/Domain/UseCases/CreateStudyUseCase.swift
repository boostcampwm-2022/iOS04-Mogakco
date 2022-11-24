//
//  CreateStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import Foundation

struct CreateStudyUseCase: CreateStudyUseCaseProtocol {
    
    private let studyRepository: StudyRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(
        studyRepository: StudyRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.studyRepository = studyRepository
        self.userRepository = userRepository
    }
    
    func create(study: Study) -> Observable<Study> {
        var study = study
        return userRepository.load()
            .compactMap { $0.id }
            .map { study.userIDs.append($0) }
            .flatMap { studyRepository.create(study: study) }
    }
}
