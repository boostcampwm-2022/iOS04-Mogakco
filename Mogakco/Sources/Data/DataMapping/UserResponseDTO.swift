//
//  UserResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UserResponseDTO: Codable {
    private let id: StringValue
    private let profileImageURLString: StringValue
    private let name: StringValue
    private let introduce: StringValue
    private let email: StringValue
    private let languages: ArrayValue<StringValue>
    private let careers: ArrayValue<StringValue>
    private let categorys: ArrayValue<StringValue>
    private let studyIDs: ArrayValue<StringValue>
    private let chatRoomIDs: ArrayValue<StringValue>
    private let fcmToken: StringValue?
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, profileImageURLString, name, introduce, email,
             languages, careers, categorys, studyIDs, chatRoomIDs, fcmToken
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.profileImageURLString = try fieldContainer.decode(StringValue.self, forKey: .profileImageURLString)
        self.name = try fieldContainer.decode(StringValue.self, forKey: .name)
        self.introduce = try fieldContainer.decode(StringValue.self, forKey: .introduce)
        self.email = try fieldContainer.decode(StringValue.self, forKey: .email)
        self.languages = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .languages)
        self.careers = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .careers)
        self.categorys = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .categorys)
        self.studyIDs = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .studyIDs)
        self.chatRoomIDs = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .chatRoomIDs)
        self.fcmToken = try fieldContainer.decodeIfPresent(StringValue.self, forKey: .fcmToken)
    }

    func toDomain() -> User {
        return User(
            id: id.value,
            profileImageURLString: profileImageURLString.value,
            email: email.value,
            introduce: introduce.value,
            password: nil,
            name: name.value,
            languages: languages.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            careers: careers.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            categorys: categorys.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            studyIDs: studyIDs.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            chatRoomIDs: chatRoomIDs.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            fcmToken: fcmToken?.value
        )
    }
}
