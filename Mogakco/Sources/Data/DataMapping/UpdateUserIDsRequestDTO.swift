//
//  UpdateUserIDsRequestDTO.swift.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/26.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UpdateUserIDsRequestDTO: Encodable {
    private let userIDs: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case userIDs
    }
    
    init(userIDs: [String]) {
        self.userIDs = ArrayValue(values: userIDs.map { StringValue(value: $0) })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.userIDs, forKey: .userIDs)
    }
}
