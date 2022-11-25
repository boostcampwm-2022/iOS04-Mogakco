//
//  StudyListUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyListUseCase: StudyListUseCaseProtocol {
    
    private let repository: StudyRepositoryProtocol
    
    init(repository: StudyRepositoryProtocol) {
        self.repository = repository
    }
    
    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]> {
        return repository.list(sort: sort, filters: filters)
    }
}
