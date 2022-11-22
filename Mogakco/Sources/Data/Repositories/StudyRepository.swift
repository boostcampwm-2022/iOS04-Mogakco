//
//  StudyRepository.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct StudyRepository: StudyRepositoryProtocol {

    private let dataSource: StudyDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    init(dataSource: StudyDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func list() -> Observable<[Study]> {
        return dataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
    }
    
    func detail(id: String) -> Observable<Study> {
        return dataSource.detail(id: id)
            .map { $0.toDomain() }
    }
}
