//
//  ReportDataSourceProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ReportDataSourceProtocol {
    func reportStudy(id: String) -> Observable<Void>
    func reportUser(id: String) -> Observable<Void>
    func loadStudy() -> Observable<[String]>
    func loadUser() -> Observable<[String]>
}
