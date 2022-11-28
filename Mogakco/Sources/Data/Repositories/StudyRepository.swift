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
    
    func list(sort: StudySort, filters: [StudyFilter]) -> Observable<[Study]> {
        return dataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { studys -> [Study] in
                switch sort {
                case .latest:
                    return studys.sorted { $0.date > $1.date }
                case .oldest:
                    return studys.sorted { $0.date < $1.date }
                }
            }
            .map { studys -> [Study] in
                return studys
                    .filter { study in
                        return !filters
                            .map { filter in
                                switch filter {
                                case .languages(let languages):
                                    return study.languages.allContains(languages)
                                case .category(let category):
                                    return study.category == category
                                }
                            }
                            .contains(false)
                    }
            }
    }
    
    func list(ids: [String]) -> Observable<[Study]> {
        return dataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } }
    }
    
    func list(ids: [String]) -> Observable<[Study]> {
        return dataSource.list()
            .map { $0.documents.map { $0.toDomain() } }
            .map { $0.filter { ids.contains($0.id) } }
    }
    
    func detail(id: String) -> Observable<Study> {
        return dataSource.detail(id: id)
            .map { $0.toDomain() }
    }
    
    func create(study: Study) -> Observable<Study> {
        let studyDTO = StudyRequestDTO(study: study)
        return dataSource.create(study: studyDTO)
            .map { $0.toDomain() }
    }
    
    func updateIDs(id: String, userIDs: [String]) -> Observable<Study> {
        let updateDTO = UpdateUserIDsRequestDTO(userIDs: userIDs)
        return dataSource.updateIDs(id: id, request: updateDTO)
            .map { $0.toDomain() }
    }
}
