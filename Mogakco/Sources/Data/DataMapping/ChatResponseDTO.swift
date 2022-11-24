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
    private let chatRoomID: StringValue
    private let date: IntegerValue
    private let readUserIDs: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, userID, message, chatRoomID, date, readUserIDs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.userID = try fieldContainer.decode(StringValue.self, forKey: .userID)
        self.message = try fieldContainer.decode(StringValue.self, forKey: .message)
        self.chatRoomID = try fieldContainer.decode(StringValue.self, forKey: .chatRoomID)
        self.date = try fieldContainer.decode(IntegerValue.self, forKey: .date)
        self.readUserIDs = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .readUserIDs)
    }
    
    func toDomain() -> Chat {
        return Chat(
            id: id.value,
            userID: userID.value,
            message: message.value,
            chatRoomID: chatRoomID.value,
            date: Int(date.value) ?? 0,
            readUserIDs: readUserIDs.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } }
        )
    }
}
