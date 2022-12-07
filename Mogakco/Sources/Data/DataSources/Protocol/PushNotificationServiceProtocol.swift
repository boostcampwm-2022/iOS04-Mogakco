//
//  PushNotificationServiceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol PushNotificationServiceProtocol {
    // FCM Token을 이용하여 특정 유저에게 푸쉬 알림 전송
    func send(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    // 특정 Topic을 구독하고 있는 유저들에게 푸쉬 알림 전송
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<EmptyResponse>
    // Topic 구독
    func subscribeTopic(topic: String)
    // Topic 구독 해제
    func unsubscribeTopic(topic: String)
}
