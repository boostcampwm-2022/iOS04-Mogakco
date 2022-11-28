//
//  JoinStudyUseCaseProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol JoinStudyUseCaseProtocol {
    func join(id: String) -> Observable<Void>
}
