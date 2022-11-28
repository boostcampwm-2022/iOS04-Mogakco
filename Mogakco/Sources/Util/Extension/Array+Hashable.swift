//
//  Array+Hashable.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var countDictionary: [Element: Int] {
        var dictionary: [Element: Int] = [:]
        self.forEach { element in
            dictionary[element, default: 0] += 1
        }
        return dictionary
    }
}
