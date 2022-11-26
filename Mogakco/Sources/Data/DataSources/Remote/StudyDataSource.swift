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
    
    func updateIDs(id: String, request: UpdateUserIDsRequestDTO) -> Observable<StudyResponseDTO> {
        return provider.request(StudyTarget.updateIDs(id, request))
    }
}

enum StudyTarget {
    case list
    case detail(String)
    case create(StudyRequestDTO)
    case updateIDs(String, UpdateUserIDsRequestDTO)
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
        case .updateIDs:
            return .patch
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
        case .updateIDs(let id, _):
            return "/\(id)"
            + "/?updateMask.fieldPaths=userIDs"
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
        case .updateIDs(_, let request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
