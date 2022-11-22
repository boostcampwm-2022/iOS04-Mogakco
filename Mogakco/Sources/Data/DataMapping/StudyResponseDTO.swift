//
//  StudyResponseDTO.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct StudyResponseDTO: Codable {
    private let id: StringValue
    private let chatRoomID: StringValue
    private let userIDs: ArrayValue<StringValue>
    private let title: StringValue
    private let content: StringValue
    private let date: IntegerValue
    private let place: StringValue
    private let maxUserCount: IntegerValue
    private let languages: ArrayValue<StringValue>
    private let category: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id
        case chatRoomID
        case userIDs
        case title
        case content
        case date
        case place
        case maxUserCount
        case languages
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.chatRoomID = try fieldContainer.decode(StringValue.self, forKey: .chatRoomID)
        self.userIDs = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .userIDs)
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.content = try fieldContainer.decode(StringValue.self, forKey: .content)
        self.date = try fieldContainer.decode(IntegerValue.self, forKey: .date)
        self.place = try fieldContainer.decode(StringValue.self, forKey: .place)
        self.maxUserCount = try fieldContainer.decode(IntegerValue.self, forKey: .maxUserCount)
        self.languages = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .languages)
        self.category = try fieldContainer.decode(StringValue.self, forKey: .category)
    }
    
    func toDomain() -> Study {
        return Study(
            id: id.value,
            chatRoomID: chatRoomID.value,
            userIDs: userIDs.arrayValue.flatMap { $0.value }.map { $0.value },
            title: title.value,
            content: content.value,
            date: date.value,
            place: place.value,
            maxUserCount: maxUserCount.value,
            languages: languages.arrayValue.flatMap { $0.value }.map { $0.value },
            category: category.value
        )
    }
}
