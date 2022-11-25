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
    
    func create(request: CreateChatRoomRequestDTO) -> Observable<ChatRoomResponseDTO> {
        return provider.request(ChatRoomTarget.create(request))
    }
    
    func updateIDs(id: String, request: UpdateUserIDRequestDTO) -> Observable<ChatRoomResponseDTO> {
        return provider.request(StudyTarget.updateIDs(id, request))
    }
}

enum ChatRoomTarget {
    case list
    case chats(String)
    case create(CreateChatRoomRequestDTO)
    case updateIDs(String, UpdateUserIDRequestDTO)
}

extension ChatRoomTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/ChatRoom"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .chats:
            return .get
        case .create:
            return .post
        case .updateIDs:
            return .patch
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
        case let .create(request):
            return "/?documentId=\(request.id.value)"
        case .updateIDs(let id, _):
            return "/\(id)"
            + "/?updateMask.fieldPaths=userIDs"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list, .chats:
            return nil
        case let .create(request):
            return .body(request)
        case .updateIDs(_, let request):
            return .body(request)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
