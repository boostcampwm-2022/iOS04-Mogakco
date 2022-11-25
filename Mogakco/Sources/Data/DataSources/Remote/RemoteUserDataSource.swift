//
//  RemoteUserDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import Firebase
import RxSwift

struct RemoteUserDataSource: RemoteUserDataSourceProtocol {
    let provider: ProviderProtocol
    
    init(provider: ProviderProtocol) {
        self.provider = provider
    }
    
    func user(id: String) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.user(id))
    }
    
    func create(request: UserRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.createUser(request))
    }
    
    func allUsers() -> Observable<Documents<[UserResponseDTO]>> {
        return provider.request(UserTarget.allUsers)
    }
    
    func editProfile(id: String, request: EditProfileRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.editProfile(id, request))
    }
    
    func editLanguages(id: String, request: EditLanguagesRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.editLanguages(id, request))
    }
    
    func editCareers(id: String, request: EditCareersRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.editCareers(id, request))
    }
    
    func editCategorys(id: String, request: EditCategorysRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.editCategorys(id, request))
    }
    
    func uploadProfileImage(id: String, imageData: Data) -> Observable<URL> {
        return Observable.create { emitter in
            let ref = Storage.storage().reference().child("User").child(id).child("profileImageURL")
            ref.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                ref.downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            emitter.onError(error)
                        }
                        // TODO: custom error
                        return
                    }
                    emitter.onNext(url)
                }
            }
            return Disposables.create()
        }
    }
    
    func updateIDs(id: String, request: UpdateStudyIDsRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.updateIDs(id, request))
    }
}

enum UserTarget {
    case user(String)
    case createUser(UserRequestDTO)
    case allUsers
    case editProfile(String, EditProfileRequestDTO)
    case editLanguages(String, EditLanguagesRequestDTO)
    case editCareers(String, EditCareersRequestDTO)
    case editCategorys(String, EditCategorysRequestDTO)
    case updateIDs(String, UpdateStudyIDsRequestDTO)
}

extension UserTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/User"
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .allUsers:
            return .get
        case .createUser:
            return .post
        case .editProfile, .editLanguages, .editCareers, .editCategorys:
            return .patch
        case .updateIDs:
            return .patch
        }
    }
    
    var header: HTTPHeaders {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var path: String {
        switch self {
        case .allUsers:
            return ""
        case let .user(id):
            return "/\(id)"
        case let .createUser(request):
            return "/?documentId=\(request.id.value)"
        case let .editProfile(id, _):
            return "/\(id)"
            + "/?updateMask.fieldPaths=name"
            + "&updateMask.fieldPaths=introduce"
            + "&updateMask.fieldPaths=profileImageURLString"
        case let .editLanguages(id, _):
            return "/\(id)" + "/?updateMask.fieldPaths=languages"
        case let .editCareers(id, _):
            return "/\(id)" + "/?updateMask.fieldPaths=careers"
        case let .editCategorys(id, _):
            return "/\(id)" + "/?updateMask.fieldPaths=categorys"
        case let .updateIDs(id, _):
            return "/\(id)"
            + "/?updateMask.fieldPaths=chatRoomIDs"
            + "&updateMask.fieldPaths=studyIDs"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .user:
            return nil
        case .allUsers:
            return nil
        case let .createUser(request):
            return .body(request)
        case let .editProfile(_, request):
            return .body(request)
        case let .editLanguages(_, request):
            return .body(request)
        case let .editCareers(_, request):
            return .body(request)
        case let .editCategorys(_, request):
            return .body(request)
        case let .updateIDs(_, request):
            return .body(request)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
