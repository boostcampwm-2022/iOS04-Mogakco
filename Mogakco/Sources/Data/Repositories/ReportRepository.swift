//
//  ReportRepository.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct ReportRepository {
    
    var reportDataSource: ReportDataSourceProtocol?
    
    func reportStudy(id: String) -> Observable<Void> {
        return reportDataSource?.reportStudy(id: id) ?? .empty()
    }
    
    func reportUser(id: String) -> Observable<Void> {
        return reportDataSource?.reportUser(id: id) ?? .empty()
    }
    
    func loadStudy() -> Observable<[String]> {
        return reportDataSource?.loadStudy() ?? .empty()
    }
    
    func loadUser() -> Observable<[String]> {
        return reportDataSource?.loadUser() ?? .empty()
    }
}
