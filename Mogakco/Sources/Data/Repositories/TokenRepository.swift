//
//  AutoLoginRepository.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct TokenRepository: TokenRepositoryProtocol {
    
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    func save(_ auth: Authorization) -> Observable<Authorization?> {
        return Observable.create { emitter in
            
            guard let data = try? JSONEncoder().encode(auth) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            guard keychainManager.save(key: auth.email, data: data) ||
                keychainManager.update(key: auth.email, data: data) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
    
    func load(email: String) -> Observable<Authorization?> {
        return Observable.create { emitter in
            
            guard let data = keychainManager.load(key: email),
                  let auth = try? JSONDecoder().decode(Authorization.self, from: data) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
    
    func delete(_ auth: Authorization) -> Observable<Authorization?> {
        return Observable.create { emitter in
            
            guard let data = try? JSONEncoder().encode(auth) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            guard keychainManager.delete(key: auth.email, data: data) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
}
