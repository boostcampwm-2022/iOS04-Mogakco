//
//  ChatRoomDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxMogakcoYa
import RxSwift

struct ChatRoomDataSource: ChatRoomDataSourceProtocol {

    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func list() -> Observable<Documents<[ChatRoomResponseDTO]>> {
        return provider.request(ChatRoomTarget.list)
    }
    
    func detail(id: String) -> Observable<ChatRoomResponseDTO> {
        return provider.request(ChatRoomTarget.detail(id))
    }
    
    func chats(id: String) -> Observable<Documents<[ChatResponseDTO]>> {
        return provider.request(ChatRoomTarget.chats(id))
            .catchAndReturn(Documents<[ChatResponseDTO]>(documents: []))
    }
    
    func create(request: CreateChatRoomRequestDTO) -> Observable<ChatRoomResponseDTO> {
        return provider.request(ChatRoomTarget.create(request))
    }
    
    func updateIDs(id: String, request: UpdateUserIDsRequestDTO) -> Observable<ChatRoomResponseDTO> {
        return provider.request(ChatRoomTarget.updateIDs(id, request))
    }
}

enum ChatRoomTarget {
    case list
    case chats(String)
    case detail(String)
    case create(CreateChatRoomRequestDTO)
    case updateIDs(String, UpdateUserIDsRequestDTO)
}

extension ChatRoomTarget: TargetType {
    var baseURL: String {
        return Network.baseURLString + "/documents/chatroom"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .detail, .chats:
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
            return "/\(id)/chat"
        case let .detail(id):
            return "/\(id)"
        case let .create(request):
            return "/?documentId=\(request.id.value)"
        case .updateIDs(let id, _):
            return "/\(id)"
            + "/?updateMask.fieldPaths=userIDs"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list, .detail, .chats:
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
