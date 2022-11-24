//
//  UserUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct UserUseCase: UserUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol
    private let studyRepository: StudyRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepositoryProtocol,
        studyRepository: StudyRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.studyRepository = studyRepository
    }
    
    func user(id: String) -> Observable<User> {
        return userRepository.user(id: id)
    }
    
    func users(ids: [String]) -> Observable<[User]> {
        return userRepository.allUsers()
            .flatMap {
                var filteredUser: [User] = []
                $0.forEach { user in
                    if ids.contains(user.id) { filteredUser.append(user) }
                }
                return Observable.just(filteredUser)
            }
	}

    func myProfile() -> Observable<User> {
        return userRepository.load()
            .compactMap { $0.id }
            .flatMap { userRepository.user(id: $0) }
            .do(onNext: {
                _ = userRepository.save(user: $0) // 저장되는지 확인 필요
            })
    }
    
    func studyList(id: String) -> Observable<[Study]> {
        return userRepository.load()
            .map { $0.studyIDs }
            .flatMap { studyRepository.list(ids: $0) }
    }
}
