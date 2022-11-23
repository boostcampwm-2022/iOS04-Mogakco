//
//  SignupUseCaseProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct SignupUseCase: SignupUseCaseProtocol {
    
    enum SignupUseCaseError: Error, LocalizedError {
        case imageCompress
    }
    
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func signup(signupProps: SignupProps) -> Observable<Void> {
        guard let imageData = signupProps.profileImage.jpegData(compressionQuality: 0.5) else {
            return Observable<Void>.error(SignupUseCaseError.imageCompress)
        }
        return authRepository.signup(signupProps: signupProps)
            .do(onNext: {_ in
                // TODO: Authroziation save to keychain
            })
            .map { $0.localId }
            .map { User(id: $0, signupProps: signupProps) }
            .flatMap { userRepository.create(user: $0, imageData: imageData) }
            .flatMap { userRepository.save(user: $0) }
    }
}
