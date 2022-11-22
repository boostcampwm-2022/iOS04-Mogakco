//
//  StudyDataSource.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

struct StudyDataSource: StudyDataSourceProtocol {

    private let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }

    func list() -> Observable<Documents<[StudyResponseDTO]>> {
        return provider.request(StudyTarget.list)
    }
    
    func detail(id: String) -> Observable<StudyResponseDTO> {
        return provider.request(StudyTarget.detail(id))
    }
}

enum StudyTarget {
    case list
    case detail(String)
}

extension StudyTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/Study"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: HTTPHeaders {
        switch self {
        case .list, .detail:
            return ["Content-Type": "application/json"]
        }
    }
    
    var path: String {
        switch self {
        case .detail(let studyID):
            return "/\(studyID)"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list, .detail:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .list, .detail:
            return JSONEncoding.default
        }
    }
}
