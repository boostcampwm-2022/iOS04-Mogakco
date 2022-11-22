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

protocol Hashtag {
    var title: String { get }
    func hashtagTitle() -> String
}

class HashtagSelectedViewModel: HashtagViewModel {
    
    let signUseCase: SignupUseCaseProtocol?
    
    init(
        coordinator: AdditionalSignupCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol,
        signUpUseCase: SignupUseCaseProtocol? = nil
    ) {
        self.signUseCase = signUpUseCase
        super.init(coordinator: coordinator, hashTagUsecase: hashTagUsecase)
    }
    
    override func transform(input: Input) -> Output {
        
        input.nextButtonTapped
            .subscribe { [weak self] in
                self?.moveToNext()
            }
            .disposed(by: disposeBag)
        
        return super.transform(input: input)
    }
    
    private func moveToNext() {
        switch kind {
        case .language: coordinator?.showCareer() // TODO: 정보 전달 로직 필요
        case .career: signUseCase?.signup(
            user: User(
                id: "",
                email: "",
                introduce: "",
                password: "",
                name: "",
                languages: [],
                careers: [],
                categorys: []
            )
        ).subscribe { _ in
            // 회원가입 후 이동
        }
        .disposed(by: disposeBag)
        case .category: break
        }
    }
}
