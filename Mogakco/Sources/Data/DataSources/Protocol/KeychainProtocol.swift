//
//  KeychainProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol KeychainProtocol {
    func add(_ query: [String: Any]) -> OSStatus
    func search(_ query: [String: Any]) -> Data?
    func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus
    func delete(_ query: [String: Any]) -> OSStatus
}
