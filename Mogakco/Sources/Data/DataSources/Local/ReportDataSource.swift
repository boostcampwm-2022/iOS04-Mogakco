//
//  ReportDataSource.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct ReportDataSource: ReportDataSourceProtocol {
    
    enum ReportType: String {
        case study
        case user
    }
    
    func reportStudy(id: String) -> Observable<Void> {
        return report(type: .study, id: id)
    }
    
    func reportUser(id: String) -> Observable<Void> {
        return report(type: .user, id: id)
    }
    
    func loadStudy() -> Observable<[String]> {
        return load(type: .study)
    }
    
    func loadUser() -> Observable<[String]> {
        return load(type: .user)
    }
    
    // MARK: - Private
    
    private func report(type: ReportType, id: String) -> Observable<Void> {
        return Observable.create { emitter in
            let list = (UserDefaults.standard.array(forKey: type.rawValue) as? [String]) ?? []
            UserDefaults.standard.set(list + [id], forKey: type.rawValue)
            emitter.onNext(())
            return Disposables.create()
        }
    }
    
    private func load(type: ReportType) -> Observable<[String]> {
        return Observable.create { emitter in
            let list = (UserDefaults.standard.array(forKey: type.rawValue) as? [String]) ?? []
            emitter.onNext(list)
            return Disposables.create()
        }
    }
}
