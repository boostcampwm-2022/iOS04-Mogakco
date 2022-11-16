//
//  SignupRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import FirebaseAuth
import RxSwift

struct FBSignupDataSource: SignupDataSource {
    
    private let firebaseAuth = Auth.auth()
    
    func signup(_ request: SignupRequestDTO) -> Single<Result<SignupResponseDTO, Error>> {
        return Single.create { single in
            // TODO: REST API, SerialBackgroundThread
            firebaseAuth.createUser(withEmail: request.email,
                                   password: request.password) { _, error in
                if let error = error {
                    single(.failure(error)) // TODO: 모각코 오류 케이스로 변환
                }
                single(.success(.success(SignupResponseDTO())))
            }
            return Disposables.create()
        }
    }
    
}
