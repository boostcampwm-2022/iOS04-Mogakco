//
//  RemoteUserDataSourceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol RemoteUserDataSourceProtocol {
    func user(id: String) -> Observable<UserResponseDTO>
    func create(request: UserRequestDTO) -> Observable<UserResponseDTO>
    func users(ids: [String]) -> Observable<[User]>
    func editProfile(id: String, request: EditProfileRequestDTO) -> Observable<UserResponseDTO>
    func uploadProfileImage(id: String, imageData: Data) -> Observable<URL>
}
