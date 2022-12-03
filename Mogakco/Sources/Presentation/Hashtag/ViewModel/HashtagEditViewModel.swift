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

    let editProfileUseCase: EditProfileUseCaseProtocol
    let finish = PublishSubject<Void>()
    
     init(
        hashTagUsecase: HashtagUseCaseProtocol,
        editProfileUseCase: EditProfileUseCaseProtocol,
        selectedHashtag: [Hashtag] = []
     ) {
         self.editProfileUseCase = editProfileUseCase
         super.init(hashTagUsecase: hashTagUsecase)
         self.selectedHashtag = selectedHashtag
    }
    
    override func transform(input: Input) -> Output {
        
        input.nextButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.tapButton()
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.finish.onNext(())
            })
            .disposed(by: disposeBag)
      
        return super.transform(input: input)
    }
    
    private func tapButton() {
        let hashtagTitles = selectedHashtag.map { $0.id }
        let changeProfile: Observable<Void>
        
        switch kind {
        case .language: changeProfile = editProfileUseCase.editLanguages(languages: hashtagTitles)
        case .career: changeProfile = editProfileUseCase.editCareers(careers: hashtagTitles)
        case .category: changeProfile = editProfileUseCase.editCategorys(categorys: hashtagTitles)
        }
        
        changeProfile
            .subscribe(onNext: { [weak self] in
                self?.finish.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
