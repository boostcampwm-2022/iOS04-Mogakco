//
//  LogoutUseCaseProtocol.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol LogoutUseCaseProtocol {
    func logout() -> Observable<Void>
}
