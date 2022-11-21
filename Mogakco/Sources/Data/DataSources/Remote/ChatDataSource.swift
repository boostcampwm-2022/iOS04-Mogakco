//
//  ChatDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

struct ChatDataSource: ChatDataSourceProtocol {

    let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }
    
    func all(chatRoomID: String) -> Observable<Documents<[ChatResponseDTO]>> {
        return provider.request(ChatTarget.all(chatRoomID))
    }
}

enum ChatTarget {
    case all(String)
}

extension ChatTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/ChatRoom"
    }
    
    var method: HTTPMethod {
        switch self {
        case .all:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .all:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var path: String {
        switch self {
        case .all(let chatRoomID):
            return "/\(chatRoomID)/chats"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .all:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .all:
            return JSONEncoding.default
        }
    }
}
