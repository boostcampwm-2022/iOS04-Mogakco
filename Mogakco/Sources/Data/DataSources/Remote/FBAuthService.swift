//
//  FBAuthService.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift

struct FBAuthService: AuthServiceProtocol {
    
    private let auth: Auth
    private let firestore: Firestore
    
    init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }

    func signup(_ request: SignupRequestDTO) -> Observable<SignupResponseDTO> {
        let signupedUserID = PublishSubject<String>()
        
        auth.createUser(withEmail: request.email, password: request.password) { result, error in
            guard let result = result,
                  error == nil else {
                      if let error = error {
                          signupedUserID.onError(error)
                      }
                    return // TODO: Custom Error
                  }
            signupedUserID.onNext(result.user.uid)
        }
        
        return signupedUserID
            .flatMap { createUser(request: request, id: $0) }
    }
    
    private func createUser(request: SignupRequestDTO, id: String) -> Observable<SignupResponseDTO> {
        return Observable.create { emitter in
            
            let data = [
                "id": id,
                "email": request.email,
                "password": request.password,
                "name": request.name,
                // "languages": request.languages,
                // "careers": request.careers
            ]
            
            firestore.collection("User").document(id).setData(data) { error in
                if let error = error {
                    emitter.onError(error)
                } else {
                    // TODO: Save User Image
                    let response = SignupResponseDTO(
                        id: id,
                        email: request.email,
                        name: request.name,
                        languages: request.languages,
                        careers: request.careers
                    )
                    emitter.onNext(response)
                }
            }
 
            return Disposables.create()
        }
    }
}
