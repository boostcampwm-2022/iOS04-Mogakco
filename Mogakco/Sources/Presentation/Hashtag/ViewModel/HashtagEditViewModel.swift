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

    var editProfileUseCase: EditProfileUseCaseProtocol?
    let finish = PublishSubject<Void>()

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
        case .language: changeProfile = editProfileUseCase?.editLanguages(languages: hashtagTitles) ?? .empty()
        case .career: changeProfile = editProfileUseCase?.editCareers(careers: hashtagTitles) ?? .empty()
        case .category: changeProfile = editProfileUseCase?.editCategorys(categorys: hashtagTitles) ?? .empty()
        }
        
        changeProfile
            .subscribe(onNext: { [weak self] in
                self?.finish.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
