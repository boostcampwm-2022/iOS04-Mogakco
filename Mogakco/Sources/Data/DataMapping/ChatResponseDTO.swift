//
//  ChatResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct ChatResponseDTO: Codable {
    private let id: StringValue
    private let userID: StringValue
    private let message: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, userID, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.userID = try fieldContainer.decode(StringValue.self, forKey: .userID)
        self.message = try fieldContainer.decode(StringValue.self, forKey: .message)
    }
    
    func toDomain() -> Chat {
        return Chat(
            id: id.value,
            userID: userID.value,
            message: message.value
        )
    }
}
