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
        static let ChatRoom = Firestore.firestore().collection("chatroom")
    }
    
    func fetchAll(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            Collection.ChatRoom
                .document(chatRoomID)
                .collection("chat")
                .order(by: "date", descending: true)
                .limit(to: 10)
                .getDocuments { snapshot, _ in
                    if let snapshot = snapshot {
                        self.page = snapshot.documents.last
                        snapshot.documents.forEach { change in
                            let dictionary = change.data()
                            guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
                                  let chat = try? JSONDecoder().decode(Chat.self, from: data)
                            else { return }
                            emitter.onNext(ChatResponseDTO(chat: chat))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func reload(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            Collection.ChatRoom
                .document(chatRoomID)
                .collection("chat")
                .order(by: "date", descending: true)
                .start(afterDocument: self.page)
                .limit(to: 5)
                .getDocuments { snapshot, _ in
                    if let snapshot = snapshot {
                        self.page = snapshot.documents.last
                        snapshot.documents.forEach({ change in
                            let dictionary = change.data()
                            guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
                                  let chat = try? JSONDecoder().decode(Chat.self, from: data)
                            else { return }
                            emitter.onNext(ChatResponseDTO(chat: chat))
                        })
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func observe(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            let query = Collection.ChatRoom.document(chatRoomID).collection("chat").order(by: "date").limit(toLast: 1)
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
            Collection.ChatRoom
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
