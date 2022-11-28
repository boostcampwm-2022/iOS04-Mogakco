//
//  CreateStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import Foundation

class CreateStudyUseCase: CreateStudyUseCaseProtocol {
    
    private let studyRepository: StudyRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let chatRoomRepository: ChatRoomRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        studyRepository: StudyRepositoryProtocol,
        userRepository: UserRepositoryProtocol,
        chatRoomRepository: ChatRoomRepositoryProtocol
    ) {
        self.studyRepository = studyRepository
        self.userRepository = userRepository
        self.chatRoomRepository = chatRoomRepository
    }
    
    func create(study: Study) -> Observable<Void> {
        
        return Observable<Void>.create { [weak self] emitter in
        
            guard let self = self else { return Disposables.create() }
            
            let user = self.userRepository.load()
            
            let createStudy = user
                .map { Study(study: study, userIDs: [$0.id]) }
                .flatMap { self.studyRepository.create(study: $0) }
            
            let createChatRoom = user
                .flatMap { user in
                    self.chatRoomRepository.create(studyID: study.id, userIDs: [user.id])
                }
            
            let updateUser = user
                .flatMap { user in
                    self.userRepository.updateIDs(
                        id: user.id,
                        chatRoomIDs: user.chatRoomIDs + [study.id],
                        studyIDs: user.chatRoomIDs + [study.id]
                    )
                }
            
            Observable
                .zip(createStudy, createChatRoom, updateUser)
                .subscribe { _ in emitter.onNext(()) }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
