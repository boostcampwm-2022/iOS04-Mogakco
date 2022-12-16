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
    
    enum TokenError: Error {
        case noToken
        case saveFail
        case deleteFail
        case decode
    }
    
    var keychainManager: KeychainManagerProtocol?
    
    func save(_ auth: Authorization) -> Observable<Authorization> {
        return Observable.create { emitter in
            guard let data = try? JSONEncoder().encode(auth) else {
                emitter.onError(TokenError.decode)
                return Disposables.create()
            }
            
            guard keychainManager?.save(key: .authorization, data: data) ?? false ||
                    keychainManager?.update(key: .authorization, data: data) ?? false else {
                emitter.onError(TokenError.saveFail)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
    
    func load() -> Observable<Authorization> {
        return Observable.create { emitter in
            guard let data = keychainManager?.load(key: .authorization),
                  let auth = try? JSONDecoder().decode(Authorization.self, from: data) else {
                emitter.onError(TokenError.noToken)
                return Disposables.create()
            }
            
            emitter.onNext(auth)
            return Disposables.create()
        }
    }
    
    func delete() -> Observable<Void> {
        return Observable.create { emitter in
            if keychainManager?.delete(key: .authorization) ?? false {
                emitter.onNext(())
            } else {
                emitter.onError(TokenError.deleteFail)
            }
            return Disposables.create()
        }
    }
}
