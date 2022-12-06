//
//  PushNotificationServiceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol PushNotificationServiceProtocol {
    // FCM Token을 이용하여 특정 유저에게 푸쉬 알림을 보내는 API
    func send(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    // 특정 Topic을 구독하고 있는 유저들에게 푸쉬 알림을 보내는 API
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    // Topic을 구독하는 API
    func subscribeTopic(topic: String)
}
