//
//  ChatRoomDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

struct ChatRoomDataSource: ChatRoomDataSourceProtocol {
    let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }
    
    func list() -> Observable<Documents<[ChatRoomResponseDTO]>> {
        return provider.request(ChatRoomTarget.list)
    }
    
    func chats(id: String) -> Observable<Documents<[ChatResponseDTO]>> {
        return provider.request(ChatRoomTarget.chats(id))
    }
}

enum ChatRoomTarget {
    case list, chats(String)
}

extension ChatRoomTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/ChatRoom"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .chats:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var path: String {
        switch self {
        case .list:
            return ""
        case let .chats(id):
            return "/\(id)/chats"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list:
            return nil
        case .chats:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
