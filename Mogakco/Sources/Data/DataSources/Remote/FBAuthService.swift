//
//  FBAuthService.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

struct FBAuthService: AuthServiceProtocol {
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }

    func signup(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO> {
        return provider.request(AuthTarget.signup(request))
    }
    
    func login(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO> {
        return provider.request(AuthTarget.login(request))
    }
    
    func withdraw(_ request: WithdrawRequestDTO) -> Observable<EmptyResponse> {
        return provider.request(AuthTarget.withdraw(request))
    }
}

enum AuthTarget {
    case signup(EmailAuthorizationRequestDTO)
    case login(EmailAuthorizationRequestDTO)
    case withdraw(WithdrawRequestDTO)
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return Network.authBaseURLString
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup:
            return .post
        case .login:
            return .post
        case .withdraw:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/accounts:signUp?key=\(Network.webAPIKey)"
        case .login:
            return "/accounts:signInWithPassword?key=\(Network.webAPIKey)"
        case .withdraw:
            return "/accounts:delete?key=\(Network.webAPIKey)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case let .signup(request):
            return .body(request)
        case let .login(request):
            return .body(request)
        case let .withdraw(request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
