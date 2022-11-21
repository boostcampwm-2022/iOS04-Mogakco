//
//  ChatRoomResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct ChatRoomResponseDTO: Codable {
    private let id: StringValue
    private let studyID: StringValue
    private let userIDs: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, studyID, messageIDs, userIDs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.studyID = try fieldContainer.decode(StringValue.self, forKey: .studyID)
        self.userIDs = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .userIDs)
    }
    
    func toDomain() -> ChatRoom {
        return ChatRoom(
            id: id.value,
            studyID: studyID.value,
            userIDs: userIDs.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } }
        )
    }
}
