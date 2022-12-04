//
//  UserUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct UserUseCase: UserUseCaseProtocol {

    var userRepository: UserRepositoryProtocol?
    var studyRepository: StudyRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func user(id: String) -> Observable<User> {
        return userRepository?.user(id: id) ?? .empty()
    }
    
    func users(ids: [String]) -> Observable<[User]> {
        return userRepository?.allUsers()
            .flatMap {
                var filteredUser: [User] = []
                $0.forEach { user in
                    if ids.contains(user.id) { filteredUser.append(user) }
                }
                return Observable.just(filteredUser)
            } ?? .empty()
	}

    func myProfile() -> Observable<User> {
        return userRepository?.load()
            .map { $0.id }
            .flatMap { userRepository?.user(id: $0) ?? .empty() }
            .do(onNext: {
                _ = userRepository?.save(user: $0) // 저장되는지 확인 필요
            }) ?? .empty()
    }
    
    func studyRatingList(studyIDs: [String]) -> Observable<[(String, Int)]> {
        return studyRepository?.list(ids: studyIDs)
            .map { $0.map { $0.category } }
            .map { $0.countDictionary }
            .map { $0.sorted { $0.value < $1.value }.map { ($0.key, $0.value) } } ?? .empty()
    }
}
