//
//  Identifiable.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return "\(self)" }
}
