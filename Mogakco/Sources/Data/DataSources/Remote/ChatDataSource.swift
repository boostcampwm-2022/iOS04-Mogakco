//
//  ChatDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import Firebase

struct ChatDataSource: ChatDataSourceProtocol {
    
    enum Collection {
        static let ChatRoom = Firestore.firestore().collection("ChatRoom")
    }
    
    func fetch(chatRoomID: String) -> Observable<[ChatResponseDTO]> {
        return Observable.create { emitter in
            var chats: [ChatResponseDTO] = []
            let query = Collection.ChatRoom.document(chatRoomID).collection("chats").order(by: "date")
            query.addSnapshotListener { snapshot, _ in
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let dictionary = change.document.data()
                        print("dict ", dictionary)
                        chats.append(ChatResponseDTO(dictionary: dictionary))
                        print("DEBUG : ", chats)
                        emitter.onNext(chats)
                    }
                })
            }
            return Disposables.create()
        }
    }
    
    func send(chat: Chat, to chatRoomID: String) -> Observable<Error?> {
        return Observable.create { emitter in
            Collection.ChatRoom.document(chatRoomID)
                .collection("chats")
                .addDocument(data: chat.toDictionary()) { data in
                    emitter.onNext(data)
                }
            return Disposables.create()
        }
    }
}
