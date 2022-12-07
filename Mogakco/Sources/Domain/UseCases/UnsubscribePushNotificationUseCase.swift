//
//  UnsubscribePushNotificationUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UnsubscribePushNotificationUseCase: UnsubscribePushNotificationUseCaseProtocol {
    
    var pushNotificationService: PushNotificationServiceProtocol?
    
    func excute(topic: String) {
        pushNotificationService?.unsubscribeTopic(topic: topic)
    }
}
