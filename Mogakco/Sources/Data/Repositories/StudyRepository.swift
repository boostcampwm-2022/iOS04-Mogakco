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
    
    func create(user: User, study: Study) -> Observable<Study> {
        return Observable<Study>.create { emitter in

            let createStudyRequest = StudyRequestDTO(study: Study(study: study, userIDs: [user.id]))
            let createStudy = (studyDataSource?.create(study: createStudyRequest) ?? .empty())

            let createChatRoomRequest = CreateChatRoomRequestDTO(id: study.id, studyID: study.id, userIDs: [user.id])
            let createChatRoom = (chatRoomDataSource?.create(request: createChatRoomRequest) ?? .empty())
                .flatMap {
                    pushNotificationService?.subscribeTopic(topic: $0.toDomain().id) ?? .empty()
                }
            
            let updateUser = (remoteUserDataSource?.updateIDs(
                id: user.id,
                request: UpdateStudyIDsRequestDTO(
                    chatRoomIDs: user.chatRoomIDs + [study.id],
                    studyIDs: user.chatRoomIDs + [study.id]
                )
            ) ?? .empty())
            
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
    
    func join(user: User, id: String) -> Observable<Void> {
        
        return Observable<Void>.create { emitter in
            let canJoinStudy = (studyDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty())
                .do(onNext: { study in
                    if study.userIDs.count >= study.maxUserCount &&
                      !study.userIDs.contains(user.id) {
                        emitter.onError(StudyRepositoryError.max)
                    }
                })
                .filter { study in
                    return study.userIDs.count < study.maxUserCount ||
                        study.userIDs.contains(user.id)
                }
                .map { _ in () }
            
            let updateUser = (remoteUserDataSource?.updateIDs(
                id: user.id,
                request: UpdateStudyIDsRequestDTO(
                    chatRoomIDs: Array(Set(user.chatRoomIDs + [id])),
                    studyIDs: Array(Set(user.studyIDs + [id]))
                )
            ) ?? .empty())

            let updateStudy = (studyDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty())
                .flatMap { study in
                    studyDataSource?.updateIDs(
                        id: study.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(study.userIDs + [user.id]))
                        )
                    ) ?? .empty()
                }

            let updateChatRoom = (chatRoomDataSource?.detail(id: id).map { $0.toDomain() } ?? .empty())
                .flatMap { chatRoom in
                    chatRoomDataSource?.updateIDs(
                        id: chatRoom.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: Array(Set(chatRoom.userIDs + [user.id]))
                        )
                    ) ?? .empty()
                }
                .map { _ in () }

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
    
    func leaveStudy(user: User, id: String) -> Observable<Void> {
        return Observable.create { emitter in
            
            // 1. User에서 정보 삭제
            let updateUser = (remoteUserDataSource?.updateIDs(
                id: user.id,
                request: UpdateStudyIDsRequestDTO(
                    chatRoomIDs: user.chatRoomIDs.filter { $0 != id },
                    studyIDs: user.studyIDs.filter { $0 != id }
                )
            ) ?? .empty())
            
            // 2. Study에서 정보 삭제
            let updateStudy = (studyDataSource?.detail(id: id) ?? .empty())
                .map { $0.toDomain() }
                .flatMap { study in
                    studyDataSource?.updateIDs(
                        id: study.id,
                        request: UpdateUserIDsRequestDTO(
                            userIDs: study.userIDs.filter { $0 != user.id }
                        )
                    ) ?? .empty()
                }
            
            // 3. ChatRoom에서 정보 삭제
            let updateChatRoom = (chatRoomDataSource?.detail(id: id) ?? .empty())
                .map { $0.toDomain() }
                .flatMap { chatRoom in
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
