//
//  LoginUseCaseProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol LoginUseCaseProtocol {
    func login(emailLoginData: EmailLogin) -> Observable<Void>
}
