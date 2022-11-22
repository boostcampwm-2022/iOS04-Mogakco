//
//  StudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyUseCase: StudyUseCaseProtocol {
    
    private let repository: StudyRepositoryProtocol
    
    init(repository: StudyRepositoryProtocol) {
        self.repository = repository
    }
    
    func list() -> RxSwift.Observable<[Study]> {
        return repository.list()
    }
    
    func detail(studyID: String) -> RxSwift.Observable<Study> {
        return repository.detail(studyID: studyID)
    }
}
