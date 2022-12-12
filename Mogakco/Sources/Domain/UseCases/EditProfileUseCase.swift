//
//  EditProfileUseCase.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

struct EditProfileUseCase: EditProfileUseCaseProtocol {
    
    enum EditProfileUseCaseError: Error, LocalizedError {
        case imageCompress
    }

    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func editProfile(name: String, introduce: String, image: UIImage) -> Observable<Void> {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return Observable<Void>.error(EditProfileUseCaseError.imageCompress)
        }
        return (userRepository?.load() ?? .empty())
            .map { $0.id }
            .flatMap {
                userRepository?.editProfile(id: $0, name: name, introduce: introduce, imageData: imageData) ?? .empty()
            }
            .map { _ in () }
    }
    
    func editLanguages(languages: [String]) -> Observable<Void> {
        return (userRepository?.load() ?? .empty())
            .map { $0.id }
            .flatMap { userRepository?.editLanguages(id: $0, languages: languages) ?? .empty() }
            .map { _ in () }
    }
    
    func editCareers(careers: [String]) -> Observable<Void> {
        return (userRepository?.load() ?? .empty())
            .compactMap { $0.id }
            .flatMap { userRepository?.editCareers(id: $0, careers: careers) ?? .empty() }
            .map { _ in () }
    }
    
    func editCategorys(categorys: [String]) -> Observable<Void> {
        return (userRepository?.load() ?? .empty())
            .map { $0.id }
            .flatMap { userRepository?.editCategorys(id: $0, categorys: categorys) ?? .empty() }
            .map { _ in () }
    }
}
