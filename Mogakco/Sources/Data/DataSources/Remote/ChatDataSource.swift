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
    
    func fetch(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            let query = Collection.ChatRoom.document(chatRoomID).collection("chatRoomID").order(by: "date")
            
            let _ = query.addSnapshotListener { snapshot, _ in
                print("@@@@@@@@ Chat FETCH @@@@@@@@")
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let dictionary = change.document.data()
                        guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
                              let chat = try? JSONDecoder().decode(Chat.self, from: data)
                        else { return }
                        emitter.onNext(ChatResponseDTO(chat: chat))
                    }
                })
            }
            return Disposables.create()
        }
    }
    
    func send(chat: Chat, to chatRoomID: String) -> Observable<Void> {
        return Observable.create { emitter in
            print("@@@@@@@@ Chat SEND @@@@@@@@")
            Collection.ChatRoom.document(chatRoomID)
                .collection("chat")
                .addDocument(data: chat.toDictionary()) { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
}
