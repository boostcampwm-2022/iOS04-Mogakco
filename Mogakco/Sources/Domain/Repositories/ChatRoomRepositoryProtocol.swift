//
//  ChatRoomRepositoryProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ChatRoomRepositoryProtocol {
    func list(id: String, ids: [String]) -> Observable<[ChatRoom]>
    func detail(id: String) -> Observable<ChatRoom>
    func create(studyID: String?, userIDs: [String]) -> Observable<ChatRoom>
    func updateIDs(id: String, userIDs: [String]) -> Observable<ChatRoom>
    func leave(user: User, chatRoom: ChatRoom) -> Observable<User>
}
