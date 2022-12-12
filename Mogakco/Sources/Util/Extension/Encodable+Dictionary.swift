//
//  Encodable+Dictionary.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/12.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
