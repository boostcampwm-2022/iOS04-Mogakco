//
//  SignupLanguageHashtagCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum SignupLanguageHashtagCoordinatorResult {
    case finish(Bool)
    case back
}

final class SignupLanguageHashtagCoordinator: BaseCoordinator<SignupLanguageHashtagCoordinatorResult> {
   
    let profileProps: ProfileProps
    let finish = PublishSubject<SignupLanguageHashtagCoordinatorResult>()
    
    init(_ profileProps: ProfileProps, _ navigationController: UINavigationController) {
        self.profileProps = profileProps
        super.init(navigationController)
    }
    
    override func start() -> Observable<SignupLanguageHashtagCoordinatorResult> {
        showLanguageHashtag()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                case .back: self?.pop(animated: true)
                }
            })
    }
    
    // MARK: - 언어 선택
    
    private func showLanguageHashtag() {
        let viewModel = HashtagSelectedViewModel(
            hashTagUsecase: HashtagUsecase(
                hashtagRepository: HashtagRepository(
                    localHashtagDataSource: HashtagDataSource())
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .next(let hashtags):
                    self?.showCareerHashtag(languages: hashtags)
                case .back:
                    self?.finish.onNext(.back)
                case .finish:
                    fatalError("do not finish")
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = HashtagSelectViewController(kind: .language, viewModel: viewModel)
        push(viewController, animated: true)
    }

    // MARK: - 직장 선택
    
    private func showCareerHashtag(languages: [Hashtag]) {
        let languageProps = profileProps.toLanguageProps(languages: languages.map { $0.id })
        let career = SignupCareerHashtagCoordinator(languageProps, navigationController)
        
        coordinate(to: career)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish(let result):
                    self?.finish.onNext(.finish(result))
                case .back:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
