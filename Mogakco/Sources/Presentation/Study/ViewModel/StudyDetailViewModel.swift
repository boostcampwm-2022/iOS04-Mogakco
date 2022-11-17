//
//  StudyDetailViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class StudyDetailViewModel: ViewModel {
    
    struct Input {
        let studyJoinButtonTapped: Observable<Void>
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        input.studyJoinButtonTapped
            .subscribe { [weak self] _ in
                self?.coordinator?.showChatDetail()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    weak var coordinator: StudyTabCoordinatorProtocol?
    var disposeBag = DisposeBag()
}
