//
//  JoinStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

class JoinStudyUseCase: JoinStudyUseCaseProtocol {
    
    enum JoinStudyUseCaseError: Error, LocalizedError {
        case max
    }
    
    private let studyRepository: StudyRepositoryProtocol
    private let chatRoomRepository: ChatRoomRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        studyRepository: StudyRepositoryProtocol,
        chatRoomRepository: ChatRoomRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.studyRepository = studyRepository
        self.chatRoomRepository = chatRoomRepository
        self.userRepository = userRepository
    }
    
    func join(id: String) -> Observable<Void> {
        
        return Observable<Void>.create { [weak self] emitter in
            
            guard let self = self else { return Disposables.create() }
            
            let canJoinStudy = Observable
                .zip(
                    self.userRepository.load(),
                    self.studyRepository.detail(id: id)
                )
                .do(onNext: { user, study in
                    if study.userIDs.count >= study.maxUserCount &&
                      !study.userIDs.contains(user.id) {
                        emitter.onError(JoinStudyUseCaseError.max)
                    }
                })
                .filter { user, study in
                    return study.userIDs.count < study.maxUserCount ||
                        study.userIDs.contains(user.id)
                }
            
            let user = canJoinStudy
                .flatMap { _ in self.userRepository.load() }
            
            let updateUser = user
                .flatMap { user in
                    self.userRepository.updateIDs(
                        id: user.id,
                        chatRoomIDs: Array(Set(user.chatRoomIDs + [id])),
                        studyIDs: Array(Set(user.studyIDs + [id]))
                    )
                }
                .flatMap { user in
                    self.userRepository.save(user: user)
                }

            let updateStudy = Observable
                .zip(
                    user,
                    self.studyRepository.detail(id: id)
                )
                .flatMap { data in
                    self.studyRepository.updateIDs(
                        id: data.1.id,
                        userIDs: Array(Set(data.1.userIDs + [data.0.id]))
                    )
                }

            let updateChatRoom = Observable
                .zip(
                    user,
                    self.chatRoomRepository.detail(id: id)
                )
                .flatMap { data in
                    self.chatRoomRepository.updateIDs(
                        id: data.1.id,
                        userIDs: Array(Set(data.1.userIDs + [data.0.id]))
                    )
                }

            Observable
                .zip(
                    updateUser,
                    updateStudy,
                    updateChatRoom
                )
                .subscribe { _ in
                    emitter.onNext(())
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
