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
    var chatRoomDataSource: ChatRoomDataSourceProtocol?
    var remoteUserDataSource: RemoteUserDataSourceProtocol?
    var studyDataSource: StudyDataSourceProtocol?
    var pushNotificationService: PushNotificationServiceProtocol?

    func create(studyID: String?, userIDs: [String]) -> Observable<ChatRoom> {
        let request = CreateChatRoomRequestDTO(
            id: studyID ?? UUID().uuidString,
            studyID: studyID,
            userIDs: userIDs
        )
        return chatRoomDataSource?.create(request: request)
            .map { $0.toDomain() } ?? .empty()
    }

    func list(id: String, ids: [String]) -> Observable<[ChatRoom]> {
        guard !ids.isEmpty else { return Observable.just([]) }

       let users = remoteUserDataSource?.allUsers()              // 유저 정보 호출
            .map { $0.documents.map { $0.toDomain() } } ?? .empty()
       
        return (chatRoomDataSource?.list() ?? .empty())         // 채팅방 목록 호출
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } }
            .flatMap { chatRooms in                             // 채팅방 내 최근 문자 추가
                return Observable.combineLatest(
                    chatRooms.map { chatRoom in
                        return (chatRoomDataSource?.chats(id: chatRoom.id) ?? .empty())
                            .map { $0.documents.map { $0.toDomain() } }
                            .map { $0.sorted { $0.date < $1.date } }
                            .map { ($0.first, unreadChatCount(id: id, chats: $0)) }
                            .map { ChatRoom(chatRoom: chatRoom, latestChat: $0.0, unreadChatCount: $0.1) }
                    }
                )
            }
            .withLatestFrom(users) { chatRooms, users in        // 채팅방 내 유저 정보 추가
                chatRooms.map { chatRoom in
                    ChatRoom(chatRoom: chatRoom, users: users.filter { chatRoom.userIDs.contains($0.id) })
                }
                .sorted {                                       // 최신 메세지 순 정렬
                    $0.latestChat?.date ?? 0 > $1.latestChat?.date ?? 0
                }
            }
    }
    
    func detail(id: String) -> Observable<ChatRoom> {
        return chatRoomDataSource?.detail(id: id)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func updateIDs(id: String, userIDs: [String]) -> Observable<ChatRoom> {
        let updateDTO = UpdateUserIDsRequestDTO(userIDs: userIDs)
        return chatRoomDataSource?.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func leave(user: User, chatRoom: ChatRoom) -> Observable<User> {
        let studyUpdated = studyDataSource?.detail(id: chatRoom.studyID ?? "")
            .map { $0.toDomain() }
            .flatMap { studyDataSource?.updateIDs(
                id: $0.id,
                request: .init(userIDs: $0.userIDs.filter { $0 != user.id })
                ) ?? .empty()
            }
            .map { _ in () }
            .catch { _ in Observable.just(()) } ?? .empty()
        
        let chatRoomUpdated = chatRoomDataSource?.detail(id: chatRoom.id)
            .map { $0.toDomain() }
            .flatMap { chatRoomDataSource?.updateIDs(
                id: $0.id,
                request: .init(userIDs: $0.userIDs.filter { $0 != user.id })
            ) ?? .empty()
            }
            .flatMap { _ in pushNotificationService?.unsubscribeTopic(topic: chatRoom.id) ?? .empty() }
            .map { _ in () } ?? .empty()
        
        let userUpdated = Observable.zip(studyUpdated, chatRoomUpdated)
            .flatMap { _ in
                remoteUserDataSource?.updateIDs(
                    id: user.id,
                    request: .init(
                        chatRoomIDs: user.chatRoomIDs.filter { $0 != chatRoom.id },
                        studyIDs: user.studyIDs.filter { $0 != chatRoom.studyID ?? "" }
                    )
                ) ?? .empty()
            }
            .map { $0.toDomain() }

        return userUpdated
    }
    
    func create(currentUserID: String, otherUserID: String) -> Observable<ChatRoom> {
        // 기존 채팅방 있는지 체크
        let originalChatRoom = (chatRoomDataSource?.list() ?? .empty())
            .map { $0.documents.map { $0.toDomain() } }
            .map { chatRooms in
                return chatRooms.filter { $0.studyID == nil
                    && $0.userIDs.allContains([currentUserID, otherUserID])
                    && $0.userIDs.count == 2
                }
            }
            .map { $0.first }
        
        // 새로운 채팅방 생성
        let createdChatRoom = originalChatRoom
            .filter { $0 == nil }
            .flatMap { _ in
                return create(studyID: nil, userIDs: [currentUserID, otherUserID])
                    .flatMap { chatRoom in
                        return Observable.zip(
                            remoteUserDataSource?.user(id: otherUserID)        // 상대 유저 DB에 업데이트
                                .map { $0.toDomain() }
                                .flatMap { otherUser in
                                    remoteUserDataSource?.updateIDs(
                                        id: otherUser.id,
                                        request: .init(
                                            chatRoomIDs: otherUser.chatRoomIDs + [chatRoom.id],
                                            studyIDs: otherUser.studyIDs
                                        )
                                    ) ?? .empty()
                                } ?? .empty(),
                            remoteUserDataSource?.user(id: currentUserID)        // 현재 유저 DB에 업데이트
                                .map { $0.toDomain() }
                                .flatMap { currentUser in
                                    remoteUserDataSource?.updateIDs(
                                        id: currentUser.id,
                                        request: .init(
                                            chatRoomIDs: currentUser.chatRoomIDs + [chatRoom.id],
                                            studyIDs: currentUser.studyIDs
                                        )
                                    ) ?? .empty()
                                } ?? .empty()
                        )
                        .map { _ in chatRoom }
                    }
            }
        
        return Observable.merge(
            originalChatRoom.compactMap { $0 },
            createdChatRoom
        )
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
