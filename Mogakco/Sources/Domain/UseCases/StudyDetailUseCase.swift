//
//  StudyDetailUseCase.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyDetailUseCase: StudyDetailUseCaseProtocol {
    
    var studyRepository: StudyRepositoryProtocol?

    func study(id: String) -> Observable<Study> {
        return studyRepository?.detail(id: id) ?? .empty()
    }
}
