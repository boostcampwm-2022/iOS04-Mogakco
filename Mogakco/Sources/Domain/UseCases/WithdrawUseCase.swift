//
//  WithdrawUseCase.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct WithdrawUseCase: WithdrawUseCaseProtocol {
    
    var userRepository: UserRepositoryProtocol?
    var authRepository: AuthRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    var chatRoomRepository: ChatRoomRepositoryProtocol?
    var studyRepository: StudyRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func withdraw(email: String) -> Observable<Void> {
        return tokenRepository?.load()
            .compactMap { $0 }
            .flatMap { authRepository?.withdraw(idToken: $0.idToken) ?? .empty() }
            .flatMap { tokenRepository?.delete() ?? .empty() }
            .map { _ in return () } ?? .empty()
    }
    
    func delete() -> Observable<Void> {
        return userRepository?.load()
            .flatMap { user in
                var observe: [Observable<Void>] = []
                user.studyIDs.forEach {
                    observe.append(self.studyRepository?.leaveStudy(id: $0) ?? .empty() )
                }
                return Observable
                    .combineLatest(observe)
                    .map { _ in return user }
            }
            .flatMap { userRepository?.delete(id: $0.id) ?? .empty() } ?? .empty()
    }
}
