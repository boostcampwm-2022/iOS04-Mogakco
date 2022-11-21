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
}

enum ChatRoomTarget {
    case list
}

extension ChatRoomTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/ChatRoom"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .list:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .list:
            return JSONEncoding.default
        }
    }
}
