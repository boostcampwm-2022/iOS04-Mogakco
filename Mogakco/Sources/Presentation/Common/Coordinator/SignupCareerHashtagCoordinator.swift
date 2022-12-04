//
//  SignupCareerHashtagCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/01.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum SignupCareerHashtagCoordinatorResult {
    case finish(Bool)
    case back
}

final class SignupCareerHashtagCoordinator: BaseCoordinator<SignupCareerHashtagCoordinatorResult> {
    
    let languageProps: LanguageProps
    let finish = PublishSubject<SignupCareerHashtagCoordinatorResult>()
    
    init(_ languageProps: LanguageProps, _ navigationController: UINavigationController) {
        self.languageProps = languageProps
        super.init(navigationController)
    }
    
    override func start() -> Observable<SignupCareerHashtagCoordinatorResult> {
        showCareerHashtag()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                case .back: self?.pop(animated: true)
                }
            })
    }
    
    func showCareerHashtag() {
        guard let viewModel = DIContainer.shared.container.resolve(HashtagSelectedViewModel.self) else { return }
        viewModel.languageProps = languageProps

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.back)
                case .finish(let result):
                    self?.finish.onNext(.finish(result))
                case .next:
                    fatalError("no more step")
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = HashtagSelectViewController(kind: .career, viewModel: viewModel)
        push(viewController, animated: true)
    }
}
