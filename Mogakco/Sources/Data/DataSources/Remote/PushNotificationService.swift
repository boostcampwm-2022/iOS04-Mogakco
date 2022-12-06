//
//  PushNotificationDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import FirebaseMessaging
import RxSwift

struct PushNotificationService: PushNotificationServiceProtocol {
    private let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }

    func send(request: PushNotificationRequestDTO) -> Observable<EmptyResponse> {
        return provider.request(PushNotificationTarget.send(request))
    }
    
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<EmptyResponse> {
        return provider.request(PushNotificationTarget.send(request))
    }
    
    func subscribeTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Message Subscribe Error \(error)")
            } else {
                print("Message Subscribe succeeded")
            }
        }
    }
}

enum PushNotificationTarget {
    case send(PushNotificationRequestDTO)
}

extension PushNotificationTarget: TargetType {
    var baseURL: String {
        return Network.fcmBaseURLStirng
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var header: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": "key=\(Network.fcmAPIKey)"
        ]
    }
    
    var path: String {
        return "/send"
    }
    
    var parameters: RequestParams? {
        switch self {
        case let .send(request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
