//
//  HashtagCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum HashtagCoordinatorResult {
    case finish([Hashtag])
}

final class HashtagCoordinator: BaseCoordinator<HashtagCoordinatorResult> {
    
    private let kind: KindHashtag
    private let selectedHashtag: [Hashtag]
    private let finish = PublishSubject<HashtagCoordinatorResult>()
    
    init(
        kind: KindHashtag,
        selectedHashtag: [Hashtag],
        _ navigationController: UINavigationController
    ) {
        self.kind = kind
        self.selectedHashtag = selectedHashtag
        super.init(navigationController)
    }
    
    override func start() -> Observable<HashtagCoordinatorResult> {
        showHashtag()
        return finish
            .do(onNext: { [weak self] _ in self?.popTabbar(animated: true) })
    }
    
    func showHashtag() {
        guard let viewModel = DIContainer.shared.container.resolve(HashtagFilterViewModel.self) else { return }
        viewModel.selectedHashtag = selectedHashtag

        viewModel.finish
            .map { HashtagCoordinatorResult.finish($0) }
            .bind(to: finish)
            .disposed(by: disposeBag)
        
        let viewController = HashtagSelectViewController(
            kind: kind,
            viewModel: viewModel
        )
        
        pushTabbar(viewController, animated: true)
    }
}
