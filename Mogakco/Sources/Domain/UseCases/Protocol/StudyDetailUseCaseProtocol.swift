//
//  StudyDetailUseCaseProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol StudyDetailUseCaseProtocol {
    func study(id: String) -> Observable<Study>
}
