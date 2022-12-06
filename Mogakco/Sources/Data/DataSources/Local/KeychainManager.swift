//
//  KeychainManager.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum KeychainKey: String {
    case userId = "com.codershigh.boostcamp.Mogakco.userId"
    case fcmToken = "com.codershigh.boostcamp.Mogakco.fcmToken"
    case authorization = "com.codershigh.boostcamp.Mogakco.authorization"
}

struct KeychainManager: KeychainManagerProtocol {
    
    var keychain: KeychainProtocol?
    
    func save(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        let status = keychain?.add(query)
        return status == errSecSuccess ? true : false
    }
    
    func load(key: KeychainKey) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        return keychain?.search(query)
    }
    
    func delete(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        let status = keychain?.delete(query)
        return status == errSecSuccess ? true : false
    }
    
    func update(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]

        let status = keychain?.update(query, with: attributes)
        return status == errSecSuccess ? true : false
    }
}
