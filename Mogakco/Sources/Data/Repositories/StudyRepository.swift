//
//  StudyRepository.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyRepository: StudyRepositoryProtocol {

    private let studyDataSource: StudyDataSourceProtocol
    private let localUserDataSource: LocalUserDataSourceProtocol
    private let remoteUserDataSource: RemoteUserDataSourceProtocol
    private let chatRoomDataSource: ChatRoomDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        studyDataSource: StudyDataSourceProtocol,
        localUserDataSource: LocalUserDataSourceProtocol,
        remoteUserDataSource: RemoteUserDataSourceProtocol,
        chatRoomDataSource: ChatRoomDataSourceProtocol
    ) {
        self.studyDataSource = studyDataSource
        self.localUserDataSource = localUserDataSource
        self.remoteUserDataSource = remoteUserDataSource
        self.chatRoomDataSource = chatRoomDataSource
    }
    
    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]> {
        return studyDataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { studys -> [Study] in
                switch sort {
                case .latest:
                    return studys.sorted { $0.date > $1.date }
                case .oldest:
                    return studys.sorted { $0.date < $1.date }
                }
            }
            .map { studys -> [Study] in
                return studys
                    .filter { study in
                        return !filters
                            .map { filter in
                                switch filter {
                                case .languages(let languages):
                                    return study.languages.allContains(languages)
                                case .category(let category):
                                    return study.category == category
                                }
                            }
                            .contains(false)
                    }
            }
    }
    
    func list(ids: [String]) -> Observable<[Study]> {
        return studyDataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } }
    }
    
    func detail(id: String) -> Observable<Study> {
        return studyDataSource.detail(id: id)
            .map { $0.toDomain() }
    }
    
    func create(study: Study) -> Observable<Study> {
        
        return Observable<Study>.create { emitter in
            
            let user = localUserDataSource.load()
            
            let createStudy = user
                .map { Study(study: study, userIDs: [$0.id]) }
                .map { StudyRequestDTO(study: $0) }
                .flatMap { studyDataSource.create(study: $0) }
            
            let createChatRoom = user
                .map {
                    CreateChatRoomRequestDTO(
                        id: study.id,
                        studyID: study.id,
                        userIDs: [$0.id]
                    )
                }
                .flatMap {
                    chatRoomDataSource.create(request: $0)
                }
            
            let updateUser = user
                .flatMap { user in
                    remoteUserDataSource.updateIDs(
                        id: user.id,
                        request: UpdateStudyIDsRequestDTO(
                            chatRoomIDs: user.chatRoomIDs + [study.id],
                            studyIDs: user.chatRoomIDs + [study.id]
                        )
                    )
                }
                .flatMap {
                    localUserDataSource.save(user: $0.toDomain())
                }
            
            Observable
                .zip(createStudy, createChatRoom, updateUser)
                .subscribe { data in emitter.onNext(data.0.toDomain()) }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func updateIDs(id: String, userIDs: [String]) -> Observable<Study> {
        let updateDTO = UpdateUserIDsRequestDTO(userIDs: userIDs)
        return studyDataSource.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() }
    }
    
    func join(id: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { emitter in
            
            let canJoinStudy = Observable
                .zip(
                    localUserDataSource.load(),
                    studyDataSource.detail(id: id).map { $0.toDomain() }
                )
                .do(onNext: { user, study in
                    if study.userIDs.count >= study.maxUserCount &&
                      !study.userIDs.contains(user.id) {
                        emitter.onNext(false)
                    }
                })
                .filter { user, study in
                    return study.userIDs.count < study.maxUserCount ||
                        study.userIDs.contains(user.id)
                }
            
            let user = canJoinStudy
                .flatMap { _ in localUserDataSource.load() }
            
            let updateUser = user
                .flatMap { user in
                    remoteUserDataSource.updateIDs(
                        id: user.id,
                        request: UpdateStudyIDsRequestDTO(
                            chatRoomIDs: Array(Set(user.chatRoomIDs + [id])),
                            studyIDs: Array(Set(user.studyIDs + [id]))
                        )
                    )
                }
                .flatMap {
                    localUserDataSource.save(user: $0.toDomain())
                }

            let updateStudy = Observable
                .zip(
                    user,
                    studyDataSource.detail(id: id).map { $0.toDomain() }
                )
                .flatMap { user, study in
                    studyDataSource.updateIDs(
                        id: study.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(study.userIDs + [user.id]))
                        )
                    )
                }

            let updateChatRoom = Observable
                .zip(
                    user,
                    chatRoomDataSource.detail(id: id).map { $0.toDomain() }
                )
                .flatMap { user, chatRoom in
                    chatRoomDataSource.updateIDs(
                        id: chatRoom.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(chatRoom.userIDs + [user.id]))
                        )
                    )
                }

            Observable
                .zip(
                    updateUser,
                    updateStudy,
                    updateChatRoom
                )
                .subscribe { _ in
                    emitter.onNext(true)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
