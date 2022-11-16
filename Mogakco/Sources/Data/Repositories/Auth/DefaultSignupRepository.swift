//
//  DefaultSignupRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct DefaultSignupRepository: SignupRepository {
    
    private var signupDataSource: SignupDataSource?
    private let disposeBag = DisposeBag()
    
    init(signupDataSource: SignupDataSource) {
        self.signupDataSource = signupDataSource
    }
    
    func signup(email: String, password: String) -> Single<Result<Void, Error>> {
        return Single.create { single in
            let request = SignupRequestDTO(email: email, password: password)
            signupDataSource?.signup(request)
                .subscribe(onSuccess: { result in
                    switch result {
                    case .success:
                        // TODO: 다른 로직 처리 및 DTO를 Domain 모델 등으로 변환
                        single(.success(.success(())))
                    case .failure(let error):
                        // TODO: 오류 대응할거 있으면 처리
                        single(.failure(error))
                    }
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
}
