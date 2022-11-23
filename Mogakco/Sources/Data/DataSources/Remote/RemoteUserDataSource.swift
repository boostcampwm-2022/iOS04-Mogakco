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
        return provider.request(UserTarget.users)
    }
    
    func editProfile(id: String, request: EditProfileRequestDTO) -> Observable<UserResponseDTO> {
        return provider.request(UserTarget.editProfile(id, request))
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
}

enum UserTarget {
    case user(String)
    case createUser(UserRequestDTO)
    case users
    case editProfile(String, EditProfileRequestDTO)
}

extension UserTarget: TargetType {
    var baseURL: String {
        return "https://firestore.googleapis.com/v1/projects/mogakco-72df7/databases/(default)/documents/User"
    }
    
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        case .users:
            return .get
        case .createUser:
            return .post
        case .editProfile:
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
        case .users:
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
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .user:
            return nil
        case .users:
            return nil
        case let .createUser(request):
            return .body(request)
        case let .editProfile(_, request):
            return .body(request)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
