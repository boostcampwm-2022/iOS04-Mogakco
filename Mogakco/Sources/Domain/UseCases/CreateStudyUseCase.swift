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
    
    func create(study: Study) -> Observable<Void> {
        var study = study
        return userRepository.load()
            .compactMap { $0.id }
            .map { study.userIDs.append($0) }
            .flatMap { studyRepository.create(study: study) } // 1. 스터디 생성
//            .flatMap { } // 2. 채팅방 생성
            .flatMap { _ in userRepository.load() } // 3. 유저 업데이트
            .flatMap {
                userRepository.updateIDs(
                    id: $0.id,
                    chatRoomIDs: $0.chatRoomIDs + [study.id],
                    studyIDs: $0.chatRoomIDs + [study.id]
                )
            }
            .map { _ in return () }
    }
}
