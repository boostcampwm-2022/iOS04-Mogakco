//
//  ReportStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ReportUseCase: ReportUseCaseProtocol {
    
    var reportRepository: ReportRepositoryProtocol?

    func reportStudy(id: String) -> Observable<Void> {
        return reportRepository?.reportStudy(id: id) ?? .empty()
    }
    
    func reportUser(id: String) -> Observable<Void> {
        return reportRepository?.reportUser(id: id) ?? .empty()
    }
}
