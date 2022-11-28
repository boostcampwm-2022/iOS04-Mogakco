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
    
    init(
        chatRoomDataSource: ChatRoomDataSourceProtocol,
        remoteUserDataSource: RemoteUserDataSourceProtocol
    ) {
        self.chatRoomDataSource = chatRoomDataSource
        self.remoteUserDataSource = remoteUserDataSource
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

       return Observable.combineLatest(latestChatChatRoomsSb, usersSb)
           .map { chatRooms, users in
               chatRooms.map { chatRoom in
                   ChatRoom(chatRoom: chatRoom, users: users.filter { chatRoom.userIDs.contains($0.id) })
               }
           }
    }
    
    func updateIDs(id: String, userIDs: [String]) -> Observable<ChatRoom> {
        let updateDTO = UpdateUserIDsRequestDTO(userIDs: userIDs)
        return chatRoomDataSource.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() }
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
