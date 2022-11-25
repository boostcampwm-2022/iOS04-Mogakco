//
//  Array+Equtable.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func allContains(_ elements: [Element]) -> Bool {
        return elements.filter { self.contains($0) }.count == elements.count
    }
}
