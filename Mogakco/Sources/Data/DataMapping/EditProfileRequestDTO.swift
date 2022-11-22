//
//  EditProfileRequestDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct EditProfileRequestDTO: Encodable {
    private let name: StringValue
    private let introduce: StringValue
    private let profileImageURLString: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case name, introduce, profileImageURLString
    }
    
    init(name: String, introduce: String, profileImageURLString: String) {
        self.name = StringValue(value: name)
        self.introduce = StringValue(value: introduce)
        self.profileImageURLString = StringValue(value: profileImageURLString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.name, forKey: .name)
        try fieldContainer.encode(self.introduce, forKey: .introduce)
        try fieldContainer.encode(self.profileImageURLString, forKey: .profileImageURLString)
    }
}
