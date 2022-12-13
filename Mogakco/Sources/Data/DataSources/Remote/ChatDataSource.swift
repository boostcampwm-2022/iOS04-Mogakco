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
            let query = Constant.chatRoom.document(chatRoomID).collection("chat")
            query.getDocuments(completion: { snapshot, _ in
                if snapshot?.isEmpty == true { query.addDocument(data: [:]) }
                self.listener = query.order(by: "date").limit(toLast: 1).addSnapshotListener({ snapshot, _ in
                    if let snapshot = snapshot,
                       let change = snapshot.documentChanges.last,
                       change.type == .added {
                        // type 지정 안하면 1. 채팅 등록 2.상대가 읽은거 인해서 총 2번 오니까 add 항목만 오게 확인 해야함
                        let dictionary = change.document.data()
                        guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
                              let chat = try? JSONDecoder().decode(Chat.self, from: data)
                        else { return }
                        emitter.onNext(ChatResponseDTO(chat: chat))
                    }
                })
            })
            return Disposables.create()
        }
    }
    
    func send(request: ChatRequestDTO) -> Observable<Void> {
        return Observable.create { emitter in
            Constant.chatRoom
                .document(request.chatRoomID)
                .collection("chat")
                .document(request.id)
                .setData(request.toDictionary()) { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
    
    func read(chat: Chat) -> Observable<Void> {
        return Observable.create { emitter in
            Constant.chatRoom
                .document(chat.chatRoomID)
                .collection("chat")
                .document(chat.id)
                .updateData(["readUserIDs": chat.readUserIDs]) { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
    
    func stopObserving() {
        listener?.remove()
        listener = nil
        page = nil
    }
}
