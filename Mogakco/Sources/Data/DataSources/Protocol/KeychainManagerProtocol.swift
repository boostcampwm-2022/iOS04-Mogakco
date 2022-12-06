//
//  KeychainManagerProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    func save(key: KeychainKey, data: Data) -> Bool
    func load(key: KeychainKey) -> Data?
    func delete(key: KeychainKey, data: Data) -> Bool
    func update(key: KeychainKey, data: Data) -> Bool
}
