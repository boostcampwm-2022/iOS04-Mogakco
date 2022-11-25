//
//  UpdateStudyIDRequestDTO.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/26.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UpdateStudyIDRequestDTO: Encodable {
    private let chatRoomIDs: ArrayValue<StringValue>
    private let studyIDs: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case chatRoomIDs, studyIDs
    }
    
    init(chatRoomIDs: [String], studyIDs: [String]) {
        self.chatRoomIDs = ArrayValue(values: chatRoomIDs.map { StringValue(value: $0) })
        self.studyIDs = ArrayValue(values: studyIDs.map { StringValue(value: $0) })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.chatRoomIDs, forKey: .chatRoomIDs)
        try fieldContainer.encode(self.studyIDs, forKey: .studyIDs)
    }
}
