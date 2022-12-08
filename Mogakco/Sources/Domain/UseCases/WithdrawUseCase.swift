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
    var tokenRepository: TokenRepositoryProtocol?
    var studyRepository: StudyRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func excute() -> Observable<Void> {
        return userRepository?.load()
            .flatMap { user in
                let observe: [Observable<Void>] = user.studyIDs.map {
                    .studyRepository?.leaveStudy(id: $0) ?? .empty()
                }
                return Observable
                    .combineLatest(observe)
                    .map { _ in return user }
            }
            .flatMap { userRepository?.delete(id: $0.id) ?? .empty() }
            .flatMap { tokenRepository?.delete() ?? .empty() }
            .map { _ in } ?? .empty()
    }
}
