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
    let userRepository: UserRepositoryProtocol
    let studyRepository: StudyRepositoryProtocol
    let chatRoomRepository: ChatRoomRepositoryProtocol
    
    func leaveStudy(id: String) -> Observable<Void> {
        return Observable.create { emitter in
            
            // 1. User에서 정보 삭제
            
            // 2. Study에서 정보 삭제
            
            // 3. ChatRoom에서 정보 삭제
            
            return Disposables.create()
        }
    }
}
