//
//  JoinStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct JoinStudyUseCase: JoinStudyUseCaseProtocol {
    
    enum JoinStudyUseCaseError: Error, LocalizedError {
        case max
    }
    
    var studyRepository: StudyRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func join(id: String) -> Observable<Void> {
        return (userRepository?.load() ?? .empty())
            .flatMap { studyRepository?.join(user: $0, id: id) ?? .empty() }
    }
}
