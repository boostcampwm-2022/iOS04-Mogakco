//
//  AutoLoginRepositoryProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol TokenRepositoryProtocol {
    func save(_ auth: Authorization) -> Observable<Authorization?>
    func load() -> Observable<Authorization?>
    func delete() -> Observable<Bool>
}
