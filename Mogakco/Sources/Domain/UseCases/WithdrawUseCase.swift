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
        print("DEBUG : withdrawUseCase Called \(email)")
        return tokenRepository?.load()
            .compactMap { $0 }
            .flatMap { authRepository?.withdraw(idToken: $0.idToken) ?? .empty() }
            .flatMap { tokenRepository?.delete() ?? .empty() }
            .map { _ in return () } ?? .empty()
    }
    
    func delete() -> Observable<Void> {
        return userRepository?.load()
            .map { user in
                return user.studyIDs.map {
                    print("DEBUG : DELETE strudy 도는 중")
                self.studyRepository?.leaveStudy(id: $0)
                        .subscribe(onNext: { _ in })
                        .disposed(by: self.disposeBag)
                }
                .map { return user }
            }
            .map { users in
                guard let user = users.first else { return }
                print("DEBUG : DELETE 정보 삭제")
                userRepository?.delete(id: user.id)
                    .subscribe(onNext: { _ in })
                    .disposed(by: self.disposeBag)
            } ?? .empty()
    }
}
