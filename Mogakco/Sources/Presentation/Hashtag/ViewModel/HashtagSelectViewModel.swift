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
    let signUseCase: SignupUseCaseProtocol?
    
    init(
        coordinator: AdditionalSignupCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol,
        signUpUseCase: SignupUseCaseProtocol? = nil
    ) {
        self.signUseCase = signUpUseCase
        self.coordinator = coordinator
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
        case .language: coordinator?.showCareer() // TODO: 정보 전달 로직 필요
        case .career: signUseCase?.signup(
            user: User(
                id: "",
                profileImageURLString: "",
                email: "",
                introduce: "",
                password: "",
                name: "",
                languages: [],
                careers: [],
                categorys: [],
                studyIDs: [],
                chatRoomIDs: []
            )
        )
        .subscribe { [weak self] _ in
            self?.coordinator?.finish(success: true)
        }
        .disposed(by: disposeBag)
        case .category: break
        }
    }
}
