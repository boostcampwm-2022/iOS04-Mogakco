//
//  CreateStudyUseCaseProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol CreateStudyUseCaseProtocol {
    func create(study: Study) -> Observable<Study>
}
