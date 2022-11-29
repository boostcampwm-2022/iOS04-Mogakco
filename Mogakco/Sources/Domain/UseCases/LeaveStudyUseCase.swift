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
    
    var disposeBag = DisposeBag()
    
    func leaveStudy(id: String) -> Observable<Void> {
        return Observable.create { emitter in
            
            // 0. User 정보 업데이트 받기
            let userInfo = userRepository
                .load()
                .flatMap { userRepository.user(id: $0.id) }
            
            // 1. User에서 정보 삭제
            let updateUser = userInfo
                .flatMap {
                    userRepository.updateIDs(
                        id: $0.id,
                        chatRoomIDs: $0.chatRoomIDs.filter { $0 != id },
                        studyIDs: $0.studyIDs.filter { $0 != id }
                    )
                }
                .flatMap {
                    userRepository.save(user: $0)
                }
            
            // 2. Study에서 정보 삭제
            let updateStudy = Observable
                .zip(
                    userInfo,
                    studyRepository.detail(id: id)
                )
                .flatMap { user, study in
                    studyRepository.updateIDs(
                        id: study.id,
                        userIDs: study.userIDs.filter { $0 != user.id }
                    )
                }
            
            // 3. ChatRoom에서 정보 삭제
            let updateChatRoom = Observable
                .zip(
                    userInfo,
                    chatRoomRepository.detail(id: id)
                )
                .flatMap { user, chatRoom in
                    chatRoomRepository.updateIDs(
                        id: chatRoom.id,
                        userIDs: chatRoom.userIDs.filter { $0 != user.id }
                    )
                }
            
            Observable.combineLatest(
                updateUser,
                updateStudy,
                updateChatRoom
            )
            .subscribe(onNext: { _ in
                emitter.onNext(())
            }, onError: { error in
                emitter.onError(error)
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
