//
//  UserRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UserRequestDTO: Codable {
    let id: StringValue
    private let profileImageURLString: StringValue
    private let name: StringValue
    private let introduce: StringValue
    private let email: StringValue
    private let languages: ArrayValue<StringValue>
    private let careers: ArrayValue<StringValue>
    private let categorys: ArrayValue<StringValue>
    private let studyIDs: ArrayValue<StringValue>
    private let chatRoomIDs: ArrayValue<StringValue>

    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, profileImageURLString, name, introduce, email, languages, careers, categorys, studyIDs, chatRoomIDs
    }
 
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.id, forKey: .id)
        try fieldContainer.encode(self.profileImageURLString, forKey: .profileImageURLString)
        try fieldContainer.encode(self.name, forKey: .name)
        try fieldContainer.encode(self.introduce, forKey: .introduce)
        try fieldContainer.encode(self.email, forKey: .email)
        try fieldContainer.encode(self.languages, forKey: .languages)
        try fieldContainer.encode(self.careers, forKey: .careers)
        try fieldContainer.encode(self.categorys, forKey: .categorys)
        try fieldContainer.encode(self.studyIDs, forKey: .studyIDs)
        try fieldContainer.encode(self.chatRoomIDs, forKey: .chatRoomIDs)
    }
    
    init(user: User) {
        self.id = StringValue(value: user.id ?? "")
        self.profileImageURLString = StringValue(value: user.profileImageURLString)
        self.name = StringValue(value: user.name)
        self.introduce = StringValue(value: user.introduce)
        self.email = StringValue(value: user.email)
        self.languages = ArrayValue<StringValue>(values: user.languages.map { StringValue(value: $0) })
        self.careers = ArrayValue<StringValue>(values: user.careers.map { StringValue(value: $0) })
        self.categorys = ArrayValue<StringValue>(values: user.categorys.map { StringValue(value: $0) })
        self.studyIDs = ArrayValue<StringValue>(values: user.studyIDs.map { StringValue(value: $0) })
        self.chatRoomIDs = ArrayValue<StringValue>(values: user.chatRoomIDs.map { StringValue(value: $0) })
    }
}
