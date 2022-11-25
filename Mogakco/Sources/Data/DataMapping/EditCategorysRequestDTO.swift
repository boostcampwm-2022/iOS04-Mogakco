//
//  EditCategorysRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/25.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct EditCategorysRequestDTO: Encodable {
    private let categorys: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case categorys
    }
    
    init(categorys: [String]) {
        self.categorys = ArrayValue<StringValue>(values: categorys.map { StringValue(value: $0) })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.categorys, forKey: .categorys)
    }
}
