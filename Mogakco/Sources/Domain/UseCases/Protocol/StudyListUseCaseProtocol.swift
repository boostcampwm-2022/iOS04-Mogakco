//
//  StudyListUseCaseProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol StudyListUseCaseProtocol {
    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]>
}
