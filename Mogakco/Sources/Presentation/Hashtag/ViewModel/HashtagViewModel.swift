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
    }
    
    let hashTagUsecase: HashtagUseCaseProtocol
    var disposeBag = DisposeBag()
    var selectedHashtag: [Hashtag] = []
    let badgeList = BehaviorSubject<[Hashtag]>(value: [])
    var kind: KindHashtag = .language
    
    var collectionViewCount: Int {
        guard let count = try? badgeList.value().count else { return 0 }
        return count
    }
    
    init(hashTagUsecase: HashtagUseCaseProtocol) {
        self.hashTagUsecase = hashTagUsecase
    }
    
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
        
        return Output(hashtagReload: collectionReloadObservable.asObservable())
    }
    
    func cellInfo(index: Int) -> Hashtag? {
        return try? badgeList.value()[index]
    }
    
    func isSelected(index: Int) -> Bool {
        guard let hashtag = cellInfo(index: index) else { return false }
        if selectedHashtag.contains(where: { $0.id == hashtag.id }) { return true }
        return false
    }
    
    private func loadTagList(kind: KindHashtag) {
        hashTagUsecase.loadTagList(kind: kind)
            .subscribe { [weak self] in
                self?.badgeList.onNext($0)
            }
            .disposed(by: disposeBag)
    }
    
    private func selectHashtag(index: Int) {
        guard let hashTag = cellInfo(index: index) else { return }
        
        if let removeIndex = selectedHashtag.firstIndex(where: { $0.id == hashTag.id }) {
            selectedHashtag.remove(at: removeIndex)
        } else {
            selectedHashtag.append(hashTag)
        }
    }
}
