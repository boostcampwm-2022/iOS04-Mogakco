//
//  ProfileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModel {
    
    struct Input {
        let editProfileButtonTapped: Observable<Void>
    }
    
    struct Output {
    }
    
    var disposeBag = DisposeBag()
    weak var coordinator: ProfileTabCoordinator?
 
    init(coordinator: ProfileTabCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        
        input.editProfileButtonTapped
            .subscribe(onNext: {
                self.coordinator?.showEditProfile()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
