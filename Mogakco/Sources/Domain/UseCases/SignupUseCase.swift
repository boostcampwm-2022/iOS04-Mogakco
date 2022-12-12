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
    
    var authRepository: AuthRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func signup(signupProps: SignupProps) -> Observable<Void> {
        guard let imageData = signupProps.profileImage.jpegData(compressionQuality: 0.5) else {
            return Observable<Void>.error(SignupUseCaseError.imageCompress)
        }
        return (authRepository?.signup(signupProps: signupProps) ?? .empty())
            .flatMap { tokenRepository?.save($0) ?? .empty() }
            .compactMap { $0 }
            .map { $0.localId }
            .map { User(id: $0, signupProps: signupProps) }
            .flatMap { userRepository?.create(user: $0, imageData: imageData) ?? .empty() }
            .map { _ in () }
    }
}
