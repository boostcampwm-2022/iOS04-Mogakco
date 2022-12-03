//
//  StudyCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/02.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum StudyListCoordinatorResult { }

final class StudyListCoordinator: BaseCoordinator<StudyListCoordinatorResult> {
    
    override func start() -> Observable<StudyListCoordinatorResult> {
        showStudyList()
        return Observable.never()
    }
    
    // MARK: - 스터디 목록
    
    func showStudyList() {
        let viewModel = StudyListViewModel(
            studyListUseCase: StudyListUseCase(
                repository: StudyRepository(
                    studyDataSource: StudyDataSource(provider: Provider.default),
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default)
                )
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .create:
                    self?.showCreateStudy()
                case .detail(let id):
                    self?.showStudyDetail(id: id)
                case .sort:
                    self?.showStudySort(sortObserver: viewModel.sort.asObserver())
                case .languageFilter:
                    self?.showHashtag(
                        kind: .language,
                        selectedHashtag: [],
                        hashtagObserver: viewModel.languageFilter.asObserver()
                    )
                case .categoryFilter:
                    self?.showHashtag(
                        kind: .category,
                        selectedHashtag: [],
                        hashtagObserver: viewModel.categoryFilter.asObserver()
                    )
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = StudyListViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 스터디 생성
    
    func showCreateStudy() {
        let viewModel = CreateStudyViewModel(
            useCase: CreateStudyUseCase(
                studyRepository: StudyRepository(
                    studyDataSource: StudyDataSource(provider: Provider.default),
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default)
                )
            )
        )
        
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
        let viewModel = SelectStudySortViewModel(sortObserver: sortObserver)
        
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
        
        coordinator(to: hashtag)
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
        coordinator(to: detail)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
