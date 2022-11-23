//
//  HashtagSelectViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HashtagSelectedViewModel: HashtagViewModel {
    
    weak var coordinator: AdditionalSignupCoordinatorProtocol?
    private let signUseCase: SignupUseCaseProtocol?
    private let profileProps: ProfileProps?
    private let languageProps: LanguageProps?
    
    init(
        coordinator: AdditionalSignupCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol,
        signUpUseCase: SignupUseCaseProtocol? = nil,
        profileProps: ProfileProps? = nil,
        languageProps: LanguageProps? = nil
    ) {
        self.signUseCase = signUpUseCase
        self.coordinator = coordinator
        self.profileProps = profileProps
        self.languageProps = languageProps
        super.init(hashTagUsecase: hashTagUsecase)
    }
    
    override func transform(input: Input) -> Output {
        
        input.nextButtonTapped
            .subscribe(onNext: { [weak self]  in
                self?.tapButton()
            })
            .disposed(by: disposeBag)
        
        return super.transform(input: input)
    }
    
    private func tapButton() {
        switch kind {
        case .language:
            guard let profileProps = profileProps else { return }
            let languageProps = profileProps.toLanguageProps(
                languages: selectedHashtag.map { $0.title }
            )
            coordinator?.showCareer(languageProps: languageProps)
            
        case .career:
            guard let languageProps = languageProps else { return }
            signUseCase?.signup(
                user: User(
                    id: "",
                    profileImageURLString: "", // TODO: 프로필 이미지 업로드해서 문자열로 바꿔야 함
                    email: languageProps.email,
                    introduce: languageProps.introduce,
                    password: languageProps.password,
                    name: languageProps.name,
                    languages: languageProps.languages,
                    careers: selectedHashtag.map { $0.title },
                    categorys: [],
                    studyIDs: [],
                    chatRoomIDs: []
                )
            )
            .subscribe { [weak self] _ in
                self?.coordinator?.finish(success: true)
            }
            .disposed(by: disposeBag)
            
        case .category:
            break
        }
    }
}
