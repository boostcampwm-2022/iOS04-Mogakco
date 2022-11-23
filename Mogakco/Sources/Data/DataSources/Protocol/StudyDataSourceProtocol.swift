//
//  StudyDataSourceProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol StudyDataSourceProtocol {
    func list() -> Observable<Documents<[StudyResponseDTO]>>
    func detail(id: String) -> Observable<StudyResponseDTO>
    func create(study: StudyRequestDTO) -> Observable<StudyResponseDTO>
}
