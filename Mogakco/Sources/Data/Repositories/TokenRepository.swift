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
    
    var keychainManager: KeychainManagerProtocol?
    
    func save(_ auth: Authorization) -> Observable<Authorization?> {
        return Observable.create { emitter in
            
            guard let data = try? JSONEncoder().encode(auth) else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            guard keychainManager?.save(key: .authorization, data: data) ?? false ||
                    keychainManager?.update(key: .authorization, data: data) ?? false else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            print("DEBUG : TokenRepository save Auth is \(auth)")
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
    
    func load() -> Observable<Authorization?> {
        return Observable.create { emitter in
            
            guard let data = keychainManager?.load(key: .authorization),
                  let auth = try? JSONDecoder().decode(Authorization.self, from: data) else {
                print("DEBUG : TokenRepository load fail. Auth is nil")
                emitter.onNext(nil)
                return Disposables.create()
            }
            print("DEBUG : TokenRepository load success. Auth is \(auth)")
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
            
            guard keychainManager?.delete(key: .authorization, data: data) ?? false else {
                emitter.onNext(nil)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
}
