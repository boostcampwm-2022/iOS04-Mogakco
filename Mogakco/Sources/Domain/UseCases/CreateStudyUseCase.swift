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
    
    var studyRepository: StudyRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func create(study: Study) -> Observable<Study> {
        return (userRepository?.load() ?? .empty())
            .flatMap { studyRepository?.create(user: $0, study: study) ?? .empty() }
    }
}
