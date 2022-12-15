//
//  StudyCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/02.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum StudyListCoordinatorResult {
    case finish
}

final class StudyListCoordinator: BaseCoordinator<StudyListCoordinatorResult> {
    
    private let finish = PublishSubject<StudyListCoordinatorResult>()
    
    override func start() -> Observable<StudyListCoordinatorResult> {
        showStudyList()
        return Observable.never()
    }
    
    // MARK: - 스터디 목록
    
    func showStudyList() {
        guard let viewModel = DIContainer.shared.container.resolve(StudyListViewModel.self) else { return }

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .create:
                    self?.showCreateStudy()
                case let .detail(id):
                    self?.showStudyDetail(id: id)
                case let .sort(observer):
                    self?.showStudySort(sortObserver: observer)
                case let .languageFilter(hashtags, observer):
                    self?.showHashtag(
                        kind: .language,
                        selectedHashtag: hashtags,
                        hashtagObserver: observer
                    )
                case let .categoryFilter(hashtags, observer):
                    self?.showHashtag(
                        kind: .category,
                        selectedHashtag: hashtags,
                        hashtagObserver: observer
                    )
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = StudyListViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 스터디 생성
    
    func showCreateStudy() {
        guard let viewModel = DIContainer.shared.container.resolve(CreateStudyViewModel.self) else { return }

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .language:
                    self?.showHashtag(
                        kind: .language,
                        selectedHashtag: [],
                        hashtagObserver: viewModel.languages.asObserver()
                    )
                case .category:
                    self?.showHashtag(
                        kind: .category,
                        selectedHashtag: [],
                        hashtagObserver: viewModel.category.asObserver()
                    )
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewContoller = CreateStudyViewController(viewModel: viewModel)
        pushTabbar(viewContoller, animated: true)
    }
    
    // MARK: - 스터디 정렬
    
    func showStudySort(sortObserver: AnyObserver<StudySort>) {
        guard let viewModel = DIContainer.shared.container.resolve(SelectStudySortViewModel.self) else { return }
        viewModel.sortObserver = sortObserver

        viewModel.finish
            .subscribe(onNext: { [weak self] in
                self?.dismissTabbar(animated: true)
            })
            .disposed(by: disposeBag)
        
        let viewController = SelectStudySortViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .pageSheet
        guard let sheet = viewController.sheetPresentationController else { return }
        sheet.detents = [
            .custom(resolver: { _ in
                return 130.0
            })
        ]
        sheet.prefersGrabberVisible = true
        presentTabbar(viewController, animated: true)
    }
    
    // MARK: - 스터디 필터
    
    func showHashtag(
        kind: KindHashtag,
        selectedHashtag: [Hashtag],
        hashtagObserver: AnyObserver<[Hashtag]>
    ) {
        let hashtag = HashtagCoordinator(
            kind: kind,
            selectedHashtag: selectedHashtag,
            navigationController
        )
        
        coordinate(to: hashtag)
            .map {
                if case .finish(let hashtags) = $0 {
                    return hashtags
                }
                return []
            }
            .bind(to: hashtagObserver)
            .disposed(by: disposeBag)
    }
    
    // MARK: - 스터디 상세
    
    func showStudyDetail(id: String) {
        let detail = StudyDetailCoordinator(id: id, navigationController)
        coordinate(to: detail)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .back:
                    self?.setNavigationBarHidden(true, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}
