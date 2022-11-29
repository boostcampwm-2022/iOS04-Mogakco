//
//  Keychain.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct Keychain: KeychainProtocol {
    
    func add(_ query: [String: Any]) -> OSStatus {
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func search(_ query: [String: Any]) -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        return status == noErr ? (item as? Data) : nil
    }
    
    func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    func delete(_ query: [String: Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
}
