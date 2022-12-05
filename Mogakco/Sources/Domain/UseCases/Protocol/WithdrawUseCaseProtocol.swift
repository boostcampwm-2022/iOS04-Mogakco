//
//  WithdrawUseCaseProtocol.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol WithdrawUseCaseProtocol {
    func withdraw(email: String) -> Observable<Void>
    func delete() -> Observable<Void>
}
