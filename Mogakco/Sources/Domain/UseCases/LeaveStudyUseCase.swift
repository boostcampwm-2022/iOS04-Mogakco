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
    var studyRepository: StudyRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    
    var disposeBag = DisposeBag()

    func leaveStudy(id: String) -> Observable<Void> {
        return (userRepository?.load() ?? .empty())
            .flatMap { studyRepository?.leaveStudy(user: $0, id: id) ?? .empty() }
    }
}
