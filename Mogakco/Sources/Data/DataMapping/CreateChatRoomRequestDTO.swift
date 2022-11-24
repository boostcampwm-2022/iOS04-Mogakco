//
//  CreateChatRoomRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/24.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct CreateChatRoomRequestDTO: Encodable {
    let id: StringValue
    private let studyID: StringValue?
    private let userIDs: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    
    private enum FieldKeys: String, CodingKey {
        case id, studyID, userIDs
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.id, forKey: .id)
        try fieldContainer.encodeIfPresent(self.studyID, forKey: .studyID)
        try fieldContainer.encode(self.userIDs, forKey: .userIDs)
    }
    
    init(id: String, studyID: String?, userIDs: [String]) {
        self.id = StringValue(value: id)
        if let studyID = studyID {
            self.studyID = StringValue(value: studyID)
        } else {
            self.studyID = nil
        }
        self.userIDs = ArrayValue<StringValue>(values: userIDs.map { StringValue(value: $0) })
    }
}
