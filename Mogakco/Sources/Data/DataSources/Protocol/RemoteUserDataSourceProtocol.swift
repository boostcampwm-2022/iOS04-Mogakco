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
    func user(request: UserRequestDTO) -> Observable<UserResponseDTO>
    func editProfile(id: String, request: EditProfileRequestDTO) -> Observable<UserResponseDTO>
    func uploadProfileImage(id: String, imageData: Data) -> Observable<URL>
}
