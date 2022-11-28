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
    func allUsers() -> Observable<Documents<[UserResponseDTO]>>
    func user(id: String) -> Observable<UserResponseDTO>
    func create(request: UserRequestDTO) -> Observable<UserResponseDTO>
    func editProfile(id: String, request: EditProfileRequestDTO) -> Observable<UserResponseDTO>
    func editLanguages(id: String, request: EditLanguagesRequestDTO) -> Observable<UserResponseDTO>
    func editCareers(id: String, request: EditCareersRequestDTO) -> Observable<UserResponseDTO>
    func editCategorys(id: String, request: EditCategorysRequestDTO) -> Observable<UserResponseDTO>
    func uploadProfileImage(id: String, imageData: Data) -> Observable<URL>
    func updateIDs(id: String, request: UpdateStudyIDsRequestDTO) -> Observable<UserResponseDTO>
}
