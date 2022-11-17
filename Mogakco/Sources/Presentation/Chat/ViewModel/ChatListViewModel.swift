//
//  ChatListViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatListViewModel: ViewModel {
    
    struct Input {
        let selectedChatRoom: Observable<Void>
    }
    
    struct Output {
    }
    
    var disposeBag = DisposeBag()
    weak var coordinator: ChatTabCoordinator?
 
    init(coordinator: ChatTabCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        
        input.selectedChatRoom
            .subscribe(onNext: {
                self.coordinator?.showChatDetail()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}

