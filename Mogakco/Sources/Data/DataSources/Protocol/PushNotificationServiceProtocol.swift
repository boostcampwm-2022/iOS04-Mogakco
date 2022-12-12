//
//  PushNotificationServiceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxMogakcoYa
import RxSwift

protocol PushNotificationServiceProtocol {
    // FCM Token을 이용하여 특정 유저에게 푸쉬 알림 전송
    func send(request: PushNotificationRequestDTO) -> Observable<Void>
    // 특정 Topic을 구독하고 있는 유저들에게 푸쉬 알림 전송
    func sendTopic(request: PushNotificationRequestDTO) -> Observable<Void>
    // Topic 구독
    func subscribeTopic(topic: String) -> Observable<Void>
    // Topic 구독 해제
    func unsubscribeTopic(topic: String) -> Observable<Void>
    // 토큰 제거
    func deleteToken() -> Observable<Void>
}
