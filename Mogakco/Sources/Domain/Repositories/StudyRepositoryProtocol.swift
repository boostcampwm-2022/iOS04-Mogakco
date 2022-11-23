//
//  StudyRepositoryProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol StudyRepositoryProtocol {
    func list() -> Observable<[Study]>
    func detail(id: String) -> Observable<Study>
    func create(study: Study) -> Observable<Study>
}
