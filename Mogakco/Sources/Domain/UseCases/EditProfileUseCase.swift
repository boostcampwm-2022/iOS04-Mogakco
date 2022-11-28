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

    private let userRepository: UserRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.userRepository = userRepository
    }
    
    func editProfile(name: String, introduce: String, image: UIImage) -> Observable<Void> {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return Observable<Void>.error(EditProfileUseCaseError.imageCompress)
        }
        return userRepository
            .load()
            .compactMap { $0.id }
            .flatMap {
                userRepository.editProfile(id: $0, name: name, introduce: introduce, imageData: imageData)
            }
            .flatMap { userRepository.save(user: $0) }
    }
    
    func editLanguages(languages: [String]) -> Observable<Void> {
        return userRepository
            .load()
            .compactMap { $0.id }
            .flatMap { userRepository.editLanguages(id: $0, languages: languages) }
            .flatMap { userRepository.save(user: $0) }
    }
    
    func editCareers(careers: [String]) -> Observable<Void> {
        return userRepository
            .load()
            .compactMap { $0.id }
            .flatMap { userRepository.editCareers(id: $0, careers: careers) }
            .flatMap { userRepository.save(user: $0) }
    }
    
    func editCategorys(categorys: [String]) -> Observable<Void> {
        return userRepository
            .load()
            .compactMap { $0.id }
            .flatMap { userRepository.editCategorys(id: $0, categorys: categorys) }
            .flatMap { userRepository.save(user: $0) }
    }
}
