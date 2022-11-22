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
    
    override func transform(input: Input) -> Output {
        
        input.nextButtonTapped
            .subscribe {
                // tap Event 처리
            }
            .disposed(by: disposeBag)
      
        return super.transform(input: input)
    }
}
