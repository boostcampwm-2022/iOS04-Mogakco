//
//  KeychainManager.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct KeychainManager: KeychainManagerProtocol {
    
    var keychain: KeychainProtocol?
    
    func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = keychain?.add(query)
        return status == errSecSuccess ? true : false
    }
    
    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        return keychain?.search(query)
    }
    
    func delete(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = keychain?.delete(query)
        return status == errSecSuccess ? true : false
    }
    
    func update(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        let status = keychain?.update(query, with: attributes)
        return status == errSecSuccess ? true : false
    }
}
