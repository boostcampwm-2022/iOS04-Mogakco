//
//  StudyRepository.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyRepository: StudyRepositoryProtocol {
    
    enum StudyRepositoryError: Error {
        case max
    }
    
    var studyDataSource: StudyDataSourceProtocol?
    var localUserDataSource: LocalUserDataSourceProtocol?
    var remoteUserDataSource: RemoteUserDataSourceProtocol?
    var chatRoomDataSource: ChatRoomDataSourceProtocol?
    var reportDataSource: ReportDataSourceProtocol?
    var pushNotificationService: PushNotificationServiceProtocol?
    private let disposeBag = DisposeBag()

    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]> {
        
        let studys = studyDataSource?.list()
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
                                    guard !languages.isEmpty else { return true }
                                    return study.languages.map { languages.contains($0) }.contains(true)
                                case .category(let category):
                                    return study.category == category
                                }
                            }
                            .contains(false)
                    }
            } ?? .empty()
        
        return Observable.zip(studys, reportDataSource?.loadStudy() ?? .empty())
            .map { studys, reportIds in
                studys.filter { !reportIds.contains($0.id) }
            }
    }
    
    func list(ids: [String]) -> Observable<[Study]> {
        return studyDataSource?.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } } ?? .empty()
    }
    
    func detail(id: String) -> Observable<Study> {
        return studyDataSource?.detail(id: id)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func create(study: Study) -> Observable<Study> {
        
        return Observable<Study>.create { emitter in
            
            let user = localUserDataSource?.load() ?? .empty()
            
            let createStudy = user
                .map { Study(study: study, userIDs: [$0.id]) }
                .map { StudyRequestDTO(study: $0) }
                .flatMap { studyDataSource?.create(study: $0) ?? .empty() }
            
            let createChatRoom = user
                .map {
                    CreateChatRoomRequestDTO(
                        id: study.id,
                        studyID: study.id,
                        userIDs: [$0.id]
                    )
                }
                .flatMap {
                    chatRoomDataSource?.create(request: $0) ?? .empty()
                }
            
            let updateUser = user
                .flatMap { user in
                    remoteUserDataSource?.updateIDs(
                        id: user.id,
                        request: UpdateStudyIDsRequestDTO(
                            chatRoomIDs: user.chatRoomIDs + [study.id],
                            studyIDs: user.chatRoomIDs + [study.id]
                        )
                    ) ?? .empty()
                }
                .flatMap {
                    localUserDataSource?.save(user: $0.toDomain()) ?? .empty()
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
        return studyDataSource?.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func join(id: String) -> Observable<Void> {
        
        return Observable<Void>.create { emitter in
            
            let canJoinStudy = Observable
                .zip(
                    localUserDataSource?.load() ?? .empty(),
                    studyDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty()
                )
                .do(onNext: { user, study in
                    if study.userIDs.count >= study.maxUserCount &&
                      !study.userIDs.contains(user.id) {
                        emitter.onError(StudyRepositoryError.max)
                    }
                })
                .filter { user, study in
                    return study.userIDs.count < study.maxUserCount ||
                        study.userIDs.contains(user.id)
                }
            
            let user = canJoinStudy
                .flatMap { _ in localUserDataSource?.load() ?? .empty() }
            
            let updateUser = user
                .flatMap { user in
                    remoteUserDataSource?.updateIDs(
                        id: user.id,
                        request: UpdateStudyIDsRequestDTO(
                            chatRoomIDs: Array(Set(user.chatRoomIDs + [id])),
                            studyIDs: Array(Set(user.studyIDs + [id]))
                        )
                    ) ?? .empty()
                }
                .flatMap {
                    localUserDataSource?.save(user: $0.toDomain()) ?? .empty()
                }

            let updateStudy = Observable
                .zip(
                    user,
                    studyDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty()
                )
                .flatMap { user, study in
                    studyDataSource?.updateIDs(
                        id: study.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(study.userIDs + [user.id]))
                        )
                    ) ?? .empty()
                }

            let updateChatRoom = Observable
                .zip(
                    user,
                    chatRoomDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty()
                )
                .flatMap { user, chatRoom in
                    chatRoomDataSource?.updateIDs(
                        id: chatRoom.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(chatRoom.userIDs + [user.id]))
                        )
                    ) ?? .empty()
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
    
    func leaveStudy(id: String) -> Observable<Void> {
        return Observable.create { emitter in
            
            // 0. User 정보 업데이트 받기
            let userInfo = localUserDataSource?.load()
                .flatMap { remoteUserDataSource?.user(id: $0.id) ?? .empty() }
                .map { $0.toDomain() } ?? .empty()
            
            // 1. User에서 정보 삭제
            let updateUser = userInfo
                .flatMap {
                    remoteUserDataSource?.updateIDs(
                        id: $0.id,
                        request: UpdateStudyIDsRequestDTO(
                            chatRoomIDs: $0.chatRoomIDs.filter { $0 != id },
                            studyIDs: $0.studyIDs.filter { $0 != id }
                        )
                    ) ?? .empty()
                }
                .map { $0.toDomain() }
                .flatMap {
                    localUserDataSource?.save(user: $0) ?? .empty()
                }
            
            // 2. Study에서 정보 삭제
            let updateStudy = Observable
                .zip(
                    userInfo,
                    studyDataSource?.detail(id: id) ?? .empty()
                )
                .map { ($0, $1.toDomain()) }
                .flatMap { user, study in
                    studyDataSource?.updateIDs(
                        id: study.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: study.userIDs.filter { $0 != user.id }
                        )
                    ) ?? .empty()
                }
            
            // 3. ChatRoom에서 정보 삭제
            let updateChatRoom = Observable
                .zip(
                    userInfo,
                    chatRoomDataSource?.detail(id: id) ?? .empty()
                )
                .map { ($0, $1.toDomain()) }
                .flatMap { user, chatRoom in
                    chatRoomDataSource?.updateIDs(
                        id: chatRoom.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: chatRoom.userIDs.filter { $0 != user.id }
                        )
                    ) ?? .empty()
                }
                .flatMap { _ in pushNotificationService?.unsubscribeTopic(topic: id) ?? .empty() }
            
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
