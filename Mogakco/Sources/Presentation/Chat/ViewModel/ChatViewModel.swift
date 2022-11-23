//
//  ChatViewModel.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatViewModel: ViewModel {
    
    struct Input {
        let backButtonDidTap: Observable<Void>
        let studyInfoButtonDidTap: Observable<Void>
        let selectedSidebar: Observable<IndexPath>
        let sendButtonDidTap: Observable<Void>
        let inputViewText: Observable<String>
    }
    
    struct Output {
        let showChatSidebarView: Observable<Void>
        let selectedSidebar: Observable<ChatSidebarMenu>
        let inputViewText: Observable<String>
    }
    
    let messages = Observable.of([1, 2, 3, 4, 5,
                                  6, 7, 8, 9, 10, 11, 12,
                                  13, 14])
    var disposeBag = DisposeBag()
    weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let showChatSidebarView = PublishSubject<Void>()
        let selectedSidebar = PublishSubject<ChatSidebarMenu>()
        let inputViewText = PublishSubject<String>()
        
        input.backButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        input.studyInfoButtonDidTap
            .subscribe(onNext: {
                showChatSidebarView.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.selectedSidebar
            .map { ChatSidebarMenu(row: $0.row) }
            .subscribe { row in
                selectedSidebar.on(row)
            }
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .subscribe(onNext: { message in
                print(message)
            })
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .withLatestFrom(input.inputViewText)
            .subscribe { message in
                inputViewText.on(message)
            }
            .disposed(by: disposeBag)
        
        return Output(
            showChatSidebarView: showChatSidebarView,
            selectedSidebar: selectedSidebar,
            inputViewText: inputViewText
        )
    }
}
