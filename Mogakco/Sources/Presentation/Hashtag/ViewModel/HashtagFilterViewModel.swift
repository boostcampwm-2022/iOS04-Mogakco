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
 
    let finish = PublishSubject<[Hashtag]>()
    
    override func transform(input: Input) -> Output {

        input.nextButtonTapped
            .subscribe(onNext: { [weak self] in
                let selectedHashtag = self?.selectedHashtag ?? []
                self?.finish.onNext(selectedHashtag)
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.finish.onNext([])
            })
            .disposed(by: disposeBag)
      
        return super.transform(input: input)
    }
}
