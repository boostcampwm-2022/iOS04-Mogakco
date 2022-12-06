//
//  PushNotificationServiceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol PushNotificationServiceProtocol {
    func send(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    func subscribeTopic(topic: String)
}
