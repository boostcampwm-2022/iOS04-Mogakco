//
//  UserDefaultsUserDataSource.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct UserDefaultsUserDataSource: LocalUserDataSourceProtocol {
    private let userKey = "user"

    func save(user: User) -> Observable<Void> {
        return Observable.create { emitter in
            do {
                let jsonData = try JSONEncoder().encode(user)
                UserDefaults.standard.set(jsonData, forKey: userKey)
                emitter.onNext(())
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }

    func load() -> Observable<User> {
        return Observable.create { emitter in
            guard let jsonData = UserDefaults.standard.value(forKey: userKey) as? Data,
                  let user = try? JSONDecoder().decode(User.self, from: jsonData) else {
                // TODO: onError
                return Disposables.create()
            }
            emitter.onNext(user)
            return Disposables.create()
        }
    }
    
    func remove() -> Observable<Void> {
        return Observable.create { emitter in
            UserDefaults.standard.removeObject(forKey: userKey)
            emitter.onNext(())
            return Disposables.create()
        }
    }
}
