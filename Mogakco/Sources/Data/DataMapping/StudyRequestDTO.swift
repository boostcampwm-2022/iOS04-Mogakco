//
//  StudyRequestDTO.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct StudyRequestDTO: Codable {
    let id: StringValue
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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.id, forKey: .id)
        try fieldContainer.encode(self.chatRoomID, forKey: .chatRoomID)
        try fieldContainer.encode(self.userIDs, forKey: .userIDs)
        try fieldContainer.encode(self.title, forKey: .title)
        try fieldContainer.encode(self.content, forKey: .content)
        try fieldContainer.encode(self.date, forKey: .date)
        try fieldContainer.encode(self.place, forKey: .place)
        try fieldContainer.encode(self.maxUserCount, forKey: .maxUserCount)
        try fieldContainer.encode(self.languages, forKey: .languages)
        try fieldContainer.encode(self.category, forKey: .category)
    }
    
    init(study: Study) {
        self.id = StringValue(value: study.id)
        self.chatRoomID = StringValue(value: study.chatRoomID)
        self.userIDs = ArrayValue<StringValue>(values: study.userIDs.map { StringValue(value: $0) })
        self.title = StringValue(value: study.title)
        self.content = StringValue(value: study.content)
        self.date = IntegerValue(value: "\(study.date)")
        self.place = StringValue(value: study.place)
        self.maxUserCount = IntegerValue(value: "\(study.maxUserCount)")
        self.languages = ArrayValue<StringValue>(values: study.languages.map { StringValue(value: $0) })
        self.category = StringValue(value: study.category)
    }
}
