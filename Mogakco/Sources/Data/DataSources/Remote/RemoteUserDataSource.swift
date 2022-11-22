//
//  RemoteUserDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

struct RemoteUserDataSource: RemoteUserDataSourceProtocol {
    let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }
    
    func user(request: UserRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.user(request))
    }
}

enum UserTarget {
    case user(UserRequestDTO)
}

extension UserTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/User"
    }
    
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .user:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var path: String {
        switch self {
        case .user(let request):
            return "/\(request.id)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .user:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .user:
            return JSONEncoding.default
        }
    }
}
