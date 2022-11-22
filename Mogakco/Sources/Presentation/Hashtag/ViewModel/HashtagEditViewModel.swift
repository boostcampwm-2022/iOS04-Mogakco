//
//  HashtagEditViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HashtagEditViewModel: HashtagViewModel {
    
    weak var coordinator: ProfileTabCoordinatorProtocol?
    let userUseCase: UserUseCaseProtocol? // 프로필 업데이트 UseCase
    weak var delegate: HashtagSelectProtocol?
    
     init(
        coordinator: ProfileTabCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol,
        userUseCase: UserUseCaseProtocol,
        selectedHashtag: [Hashtag]
     ) {
         self.userUseCase = userUseCase
         self.coordinator = coordinator
         super.init(hashTagUsecase: hashTagUsecase)
         self.selectedHashtag = selectedHashtag
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
        // 1. userUseCase 에서 업데이트
        delegate?.selectedHashtag(hashTags: selectedHashtag) // 2. 상위 뷰컨에 전달
        // 3. 화면이동
    }
}
