//
//  ChatDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import Firebase

final class ChatDataSource: ChatDataSourceProtocol {
    
    var listener: ListenerRegistration?
    var page: DocumentSnapshot?
    
    enum Collection {
        static let chatRoom = Firestore.firestore().collection("chatroom")
    }
    
    func fetchAll(chatRoomID: String) -> Observable<[ChatResponseDTO]> {
        return Observable.create { emitter in
            Collection.chatRoom
                .document(chatRoomID)
                .collection("chat")
                .order(by: "date")
                .limit(toLast: 5)
                .getDocuments { snapshot, _ in
                    if let snapshot = snapshot {
                        self.page = snapshot.documents.first

                        let chats = snapshot.documents
                            .map { $0.data() }
                            .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                            .compactMap { try? JSONDecoder().decode(Chat.self, from: $0) }
                            .map { ChatResponseDTO(chat: $0) }
                        emitter.onNext(chats)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    
    func reload(chatRoomID: String) -> Observable<[ChatResponseDTO]> {
        
        return Observable.create { emitter in
            guard let page = self.page else { return Disposables.create() }
                Collection.chatRoom
                    .document(chatRoomID)
                    .collection("chat")
                    .order(by: "date")
                    .end(beforeDocument: page)
                    .limit(toLast: 5)
                    .getDocuments { snapshot, _ in
                        if let snapshot = snapshot {
                            self.page = snapshot.documents.first
                            let chats = snapshot.documents
                                .map { $0.data() }
                                .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                                .compactMap { try? JSONDecoder().decode(Chat.self, from: $0) }
                                .map { ChatResponseDTO(chat: $0) }
                            emitter.onNext(chats)
                        }
                    }
            return Disposables.create()
        }
    }
    
    func observe(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            let query = Collection.chatRoom.document(chatRoomID).collection("chat").order(by: "date").limit(toLast: 1)
            self.listener = query.addSnapshotListener({ snapshot, _ in
                if let snapshot = snapshot,
                   let dictionary = snapshot.documents.last?.data() {
                    guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
                          let chat = try? JSONDecoder().decode(Chat.self, from: data)
                    else { return }
                    emitter.onNext(ChatResponseDTO(chat: chat))
                }
            })
            return Disposables.create()
        }
    }
    
    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return Observable.create { emitter in
            Collection.chatRoom
                .document(chatRoomID)
                .collection("chat")
                .addDocument(data: chat.toDictionary()) { _ in
                    print("@@@@@@@@ Chat SEND @@@@@@@@")
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
}
