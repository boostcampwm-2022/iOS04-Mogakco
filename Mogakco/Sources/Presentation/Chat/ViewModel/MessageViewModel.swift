//
//  MessageViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/20.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

struct MessageViewModel {
    
    struct Input {
    }
    
    struct Output {
        let isFromCurrentUser: Observable<Bool>
    }
    
    let chat: Chat
    private let chatUseCase: ChatUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(
        chat: Chat,
        chatUseCase: ChatUseCaseProtocol
    ) {
        self.chat = chat
        self.chatUseCase = chatUseCase
    }
    
    func transform() -> Output {
        let isFromCurrentUser = PublishSubject<Bool>()
        
        chatUseCase.myProfile()
            .map { print("@", 1); return $0.id == chat.id }
            .subscribe(isFromCurrentUser)
            .disposed(by: disposeBag)
        
        return Output(
            isFromCurrentUser: isFromCurrentUser
        )
    }
}
