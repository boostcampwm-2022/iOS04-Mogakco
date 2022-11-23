//
//  CreateStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct CreateStudyUseCase: CreateStudyUseCaseProtocol {
    
    private let repository: StudyRepositoryProtocol
    
    init(repository: StudyRepositoryProtocol) {
        self.repository = repository
    }
    
    func create(study: Study) -> Observable<Study> {
        return repository.create(study: study)
    }
}
