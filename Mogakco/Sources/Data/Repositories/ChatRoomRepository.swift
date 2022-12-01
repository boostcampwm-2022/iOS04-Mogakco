//
//  ChatRoomRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct ChatRoomRepository: ChatRoomRepositoryProtocol {
    
    private let disposeBag = DisposeBag()
    private let chatRoomDataSource: ChatRoomDataSourceProtocol
    private let remoteUserDataSource: RemoteUserDataSourceProtocol
    private let studyDataSource: StudyDataSource
    
    init(
        chatRoomDataSource: ChatRoomDataSourceProtocol,
        remoteUserDataSource: RemoteUserDataSourceProtocol,
        studyDataSource: StudyDataSource
    ) {
        self.chatRoomDataSource = chatRoomDataSource
        self.remoteUserDataSource = remoteUserDataSource
        self.studyDataSource = studyDataSource
    }
    
    func create(studyID: String?, userIDs: [String]) -> Observable<ChatRoom> {
        let request = CreateChatRoomRequestDTO(
            id: studyID ?? UUID().uuidString,
            studyID: studyID,
            userIDs: userIDs
        )
        return chatRoomDataSource.create(request: request)
            .map { $0.toDomain() }
    }

    func list(id: String, ids: [String]) -> Observable<[ChatRoom]> {
        guard !ids.isEmpty else {
            return Observable.just([])
        }
        // 채팅방 모델 호출
        let chatRoomsSb = chatRoomDataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } }
        
        // 최근 메세지 호출
        let latestChatChatRoomsSb = BehaviorSubject<[ChatRoom]>(value: [])
        chatRoomsSb
            .subscribe(onNext: { chatRooms in
                chatRooms.forEach { chatRoom in
                    chatRoomDataSource.chats(id: chatRoom.id)
                        .map { $0.documents.map { $0.toDomain() } }
                        .map { $0.sorted { $0.date < $1.date } } // TODO: 메세지 정렬 API 쿼리로 이동
                        .map { ($0.first, unreadChatCount(id: id, chats: $0)) }
                        .map { ChatRoom(chatRoom: chatRoom, latestChat: $0.0, unreadChatCount: $0.1) }
                        .withLatestFrom(latestChatChatRoomsSb) { $1 + [$0] }
                        .map { $0.sorted { $0.latestChat?.date ?? 0 < $1.latestChat?.date ?? 0 } }
                        .subscribe(onNext: {
                            latestChatChatRoomsSb.onNext($0)
                        })
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        // 유저 정보 호출
       let usersSb = remoteUserDataSource
            .allUsers()
            .map { $0.documents.map { $0.toDomain() } }

       return Observable.combineLatest(
        latestChatChatRoomsSb
            .withLatestFrom(chatRoomsSb) { ($0, $1) }
            .filter { $0.0.count == $0.1.count }
            .map { $0.0 },
        usersSb
       )
           .map { chatRooms, users in
               chatRooms.map { chatRoom in
                   ChatRoom(chatRoom: chatRoom, users: users.filter { chatRoom.userIDs.contains($0.id) })
               }
           }
    }
    
    func detail(id: String) -> Observable<ChatRoom> {
        return chatRoomDataSource.detail(id: id)
            .map { $0.toDomain() }
    }
    
    func updateIDs(id: String, userIDs: [String]) -> Observable<ChatRoom> {
        let updateDTO = UpdateUserIDsRequestDTO(userIDs: userIDs)
        return chatRoomDataSource.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() }
    }
    
    func leave(user: User, chatRoom: ChatRoom) -> Observable<User> {
        let studyUpdated = studyDataSource.detail(id: chatRoom.studyID ?? "")
            .map { $0.toDomain() }
            .flatMap { studyDataSource.updateIDs(
                id: $0.id,
                request: .init(userIDs: $0.userIDs.filter { $0 != user.id })
                )
            }
            .map { _ in () }
            .catch { _ in Observable.just(()) }
        
        let chatRoomUpdated = chatRoomDataSource.detail(id: chatRoom.id)
            .map { $0.toDomain() }
            .flatMap { chatRoomDataSource.updateIDs(
                id: $0.id,
                request: .init(userIDs: $0.userIDs.filter { $0 != user.id })
                )
            }
            .map { _ in () }
        
        let userUpdated = Observable.zip(studyUpdated, chatRoomUpdated)
            .flatMap { _ in
                remoteUserDataSource.updateIDs(
                    id: user.id,
                    request: .init(
                        chatRoomIDs: user.chatRoomIDs.filter { $0 != chatRoom.id },
                        studyIDs: user.studyIDs.filter { $0 != chatRoom.studyID ?? "" }
                    )
                )
            }
            .map { $0.toDomain() }

        return userUpdated
    }
    
    func create(currentUserID: String, otherUserID: String) -> Observable<ChatRoom> {
        let chatRoomSb = PublishSubject<ChatRoom>()
        let createChatRoom = PublishSubject<Void>()
        
        // 기존 채팅방 있는지 체크
        chatRoomDataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { chatRooms in
                return chatRooms.filter { $0.studyID == nil
                    && $0.userIDs.allContains([currentUserID, otherUserID])
                    && $0.userIDs.count == 2
                }
            }
            .map { $0.first }
            .subscribe(onNext: { chatRoom in
                if let chatRoom = chatRoom {
                    chatRoomSb.onNext(chatRoom)
                } else {
                    createChatRoom.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        // 새로운 채팅방 생성
        createChatRoom
            .flatMap {
                return create(studyID: nil, userIDs: [currentUserID, otherUserID])
                    .flatMap { chatRoom in
                        return Observable.zip(
                            remoteUserDataSource.user(id: otherUserID)
                                .map { $0.toDomain() }
                                .flatMap { otherUser in
                                    remoteUserDataSource.updateIDs(
                                        id: otherUser.id,
                                        request: .init(
                                            chatRoomIDs: otherUser.chatRoomIDs + [chatRoom.id],
                                            studyIDs: otherUser.studyIDs
                                        )
                                    )
                                },
                            remoteUserDataSource.user(id: currentUserID)
                                .map { $0.toDomain() }
                                .flatMap { currentUser in
                                    remoteUserDataSource.updateIDs(
                                        id: currentUser.id,
                                        request: .init(
                                            chatRoomIDs: currentUser.chatRoomIDs + [chatRoom.id],
                                            studyIDs: currentUser.studyIDs
                                        )
                                    )
                                }
                        )
                        .map { _ in chatRoom }
                    }
            }
            .subscribe(onNext: {
                chatRoomSb.onNext($0)
            })
            .disposed(by: disposeBag)
        
        return chatRoomSb
    }
    
    private func unreadChatCount(id: String, chats: [Chat]) -> Int {
        var count = 0
        for chat in chats {
            if !chat.readUserIDs.contains(id) {
                count += 1
            } else {
                break
            }
        }
        return count
    }
}
