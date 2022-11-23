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
    
    func create(study: StudyRequestDTO) -> Observable<StudyResponseDTO> {
        return provider.request(StudyTarget.create(study))
    }
}

enum StudyTarget {
    case list
    case detail(String)
    case create(StudyRequestDTO)
}

extension StudyTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/Study"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .detail:
            return .get
        case .create:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .detail(let id):
            return "/\(id)"
        case .create(let study):
            return "/?documentId=\(study.id.value)"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list, .detail:
            return nil
        case .create(let study):
            return .body(study)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
