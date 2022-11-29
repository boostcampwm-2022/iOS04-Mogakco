//
//  KeychainManagerProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    func save(key: String, data: Data) -> Bool
    func load(key: String) -> Data?
    func delete(key: String, data: Data) -> Bool
    func update(key: String, data: Data) -> Bool
}
