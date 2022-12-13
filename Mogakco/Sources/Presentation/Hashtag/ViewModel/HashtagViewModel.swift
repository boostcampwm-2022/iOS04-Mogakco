//
//  HashtagViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HashtagViewModel: ViewModel {
    
    struct Input {
        let kindHashtag: Observable<KindHashtag>
        let cellSelected: Observable<Int>
        let nextButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let hashtagReload: Observable<Void>
        let alert: Signal<Alert>
    }
    
    var hashTagUsecase: HashtagUseCaseProtocol?
    var disposeBag = DisposeBag()
    var selectedHashtags: [Hashtag] = []
    let badgeList = BehaviorSubject<[Hashtag]>(value: [])
    var kind: KindHashtag = .language
    let alert = PublishSubject<Alert>()
    
    var collectionViewCount: Int {
        guard let count = try? badgeList.value().count else { return 0 }
        return count
    }
    
    init() { }
    
    func transform(input: Input) -> Output {
        let collectionReloadObservable = PublishSubject<Void>()
        
        input.kindHashtag
            .subscribe { [weak self] in
                self?.loadTagList(kind: $0)
                self?.kind = $0
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .withUnretained(self)
            .subscribe { owner, index in
                owner.selectHashtag(index: index)
            }
            .disposed(by: disposeBag)
        
        badgeList
            .subscribe { _ in
                collectionReloadObservable.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            hashtagReload: collectionReloadObservable.asObservable(),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    func cellInfo(index: Int) -> Hashtag? {
        return try? badgeList.value()[index]
    }
    
    func isSelected(index: Int) -> Bool {
        guard let hashtag = cellInfo(index: index) else { return false }
        if selectedHashtags.contains(where: { $0.id == hashtag.id }) { return true }
        return false
    }
    
    private func loadTagList(kind: KindHashtag) {
        (hashTagUsecase?.loadTagList(kind: kind).asResult() ?? .empty())
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let badges):
                    viewModel.badgeList.onNext(badges)
                case .failure:
                    let alert = Alert(title: "해시태그 로드 오류", message: "해시태그 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func selectHashtag(index: Int) {
        guard let hashTag = cellInfo(index: index) else { return }
        
        if let removeIndex = selectedHashtags.firstIndex(where: { $0.id == hashTag.id }) {
            selectedHashtags.remove(at: removeIndex)
        } else {
            selectedHashtags.append(hashTag)
        }
    }
}
