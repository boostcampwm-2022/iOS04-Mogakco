//
//  HashtagFilterViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HashtagFilterViewModel: HashtagViewModel {
    
    weak var coordinator: StudyTabCoordinatorProtocol?
    weak var delegate: HashtagSelectProtocol?
    
     init(
        coordinator: StudyTabCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol,
        selectedHashtag: [Hashtag]
     ) {
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
        delegate?.selectedHashtag(hashTags: selectedHashtag) // 1. 상위 뷰컨에 전달
        // 2. 화면 이동
    }
}
