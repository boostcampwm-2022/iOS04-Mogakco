//
//  StudyListUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyListUseCase: StudyListUseCaseProtocol {
    
    var studyRepository: StudyRepositoryProtocol?

    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]> {
        return studyRepository?.list(sort: sort, filters: filters) ?? .empty()
    }
}
