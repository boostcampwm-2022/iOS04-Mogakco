//
//  PushNotificationDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import FirebaseMessaging
import RxMogakcoYa
import RxSwift

struct PushNotificationService: PushNotificationServiceProtocol {
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }

    func send(request: PushNotificationRequestDTO) -> Observable<Void> {
        return provider.request(PushNotificationTarget.send(request))
    }
    
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<Void> {
        return provider.request(PushNotificationTarget.send(request))
    }
    
    func subscribeTopic(topic: String) -> Observable<Void> {
        return Observable.create { emitter in
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    emitter.onError(error)
                }
                emitter.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func unsubscribeTopic(topic: String) -> Observable<Void> {
        return Observable.create { emitter in
            Messaging.messaging().unsubscribe(fromTopic: topic) { error in
                if let error = error {
                    emitter.onError(error)
                }
                emitter.onNext(())
            }
            return Disposables.create()
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
