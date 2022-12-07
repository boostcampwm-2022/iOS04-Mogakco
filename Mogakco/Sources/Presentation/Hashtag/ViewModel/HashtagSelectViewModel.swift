//
//  HashtagSelectViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

enum HashtagSelectedeNavigation {
    case next([Hashtag])
    case finish(Bool)
    case back
}

class HashtagSelectedViewModel: HashtagViewModel {
    
    var signUseCase: SignupUseCaseProtocol?
    var languageProps: LanguageProps?
    let navigation = PublishSubject<HashtagSelectedeNavigation>()

    override func transform(input: Input) -> Output {

        input.nextButtonTapped
            .withUnretained(self)
            .filter { $0.0.kind == .language }
            .map { HashtagSelectedeNavigation.next($0.0.selectedHashtags) }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.nextButtonTapped
            .withUnretained(self)
            .filter { $0.0.kind == .career }
            .subscribe(onNext: { $0.0.signup() })
            .disposed(by: disposeBag)

        input.backButtonTapped
            .map { HashtagSelectedeNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return super.transform(input: input)
    }

    private func signup() {
        guard let languageProps = languageProps else { return }
        let careers = selectedHashtags.map { $0.id }
        let signupProps = languageProps.toSignupProps(careers: careers)
        signUseCase?.signup(signupProps: signupProps)
            .subscribe { [weak self] _ in
                self?.navigation.onNext(.finish(true))
            }
            .disposed(by: disposeBag)
    }
}
