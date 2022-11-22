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
        let profileImageURL: Observable<URL>
        let name: Observable<String>
        let introduce: Observable<String>
        let languages: Observable<[String]>
        let careers: Observable<[String]>
        let categorys: Observable<[String]>
    }
    
    var disposeBag = DisposeBag()
    weak var coordinator: ProfileTabCoordinator?
    let profileUseCase: ProfileUseCase
 
    init(
        coordinator: ProfileTabCoordinator,
        profileUseCase: ProfileUseCase
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
    
    func transform(input: Input) -> Output {
        input.editProfileButtonTapped
            .subscribe(onNext: {
                self.coordinator?.showEditProfile()
            })
            .disposed(by: disposeBag)
        
        let user = Observable.just(())
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase.profile() }
        
        return Output(
            profileImageURL: user.compactMap { URL(string: $0.profileImageURLString) },
            name: user.map { $0.name }.asObservable(),
            introduce: user.map { $0.introduce }.asObservable(),
            languages: user.map { $0.languages }.asObservable(),
            careers: user.map { $0.careers }.asObservable(),
            categorys: user.map { $0.categorys }.asObservable()
        )
    }
}
