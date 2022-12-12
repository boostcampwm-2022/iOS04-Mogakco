//
//  FBAuthService.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxMogakcoYa
import RxSwift

struct FBAuthService: AuthServiceProtocol {
    
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }

    func signup(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO> {
        return provider.request(AuthTarget.signup(request))
    }
    
    func login(_ request: EmailAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO> {
        return provider.request(AuthTarget.login(request))
    }
}

enum AuthTarget {
    case signup(EmailAuthorizationRequestDTO)
    case login(EmailAuthorizationRequestDTO)
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
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case let .signup(request):
            return .body(request)
        case let .login(request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
