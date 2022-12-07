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
    let disposeBag = DisposeBag()
    
    enum Constant {
        static let chatRoom = Firestore.firestore().collection("chatroom")
        static let pagination = 7
    }
    
    private func query(chatRoomID: String) -> Observable<Query> {
        return Observable.create { emitter in
            var query = Constant.chatRoom
                .document(chatRoomID)
                .collection("chat")
                .order(by: "date")
            if let page = self.page {
                query = query.end(beforeDocument: page)
            }
            emitter.onNext(query)
            return Disposables.create()
        }
    }
    
    func fetch(chatRoomID: String) -> Observable<[ChatResponseDTO]> {
        return Observable.create { emitter in
            _ = self.query(chatRoomID: chatRoomID)
                .map { query in
                    query.limit(toLast: Constant.pagination)
                        .getDocuments { snapshot, _ in
                            if let snapshot = snapshot,
                               !snapshot.documents.isEmpty {
                                self.page = snapshot.documents.first
                                
                                let chats = snapshot.documents
                                    .map { $0.data() }
                                    .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                                    .compactMap { try? JSONDecoder().decode(Chat.self, from: $0) }
                                    .map { ChatResponseDTO(chat: $0) }
                                emitter.onNext(chats)
                            }
                        }
                }
                .subscribe { _ in }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func observe(chatRoomID: String) -> Observable<ChatResponseDTO> {
        return Observable.create { emitter in
            let query = Constant.chatRoom.document(chatRoomID).collection("chat").order(by: "date").limit(toLast: 1)
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
            Constant.chatRoom
                .document(chatRoomID)
                .collection("chat")
                .document(chat.id)
                .setData(chat.toDictionary()) { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
}
