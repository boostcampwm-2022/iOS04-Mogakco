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

enum KindHashtag {
    case language
    case career
    case category
}

protocol Hashtag {
    var title: String { get }
    func hashtagTitle() -> String
}

final class HashtagSelectViewModel: ViewModel {
    
    struct Input {
        let kindHashtag: Observable<KindHashtag>
        let cellSelected: ControlEvent<IndexPath>
        let nextButtonTapped: Observable<Void>
    }
    struct Output {
        let hashtagReload: Observable<Void>
    }
    
    weak var coordinator: AdditionalSignupCoordinatorProtocol?
    let hashTagUsecase: HashtagUseCaseProtocol
    var disposeBag = DisposeBag()
    var selectedHashtag: [Hashtag] = []
    let badgeList = BehaviorSubject<[Hashtag]>(value: [])
    
    var collectionViewCount: Int {
        guard let count = try? badgeList.value().count else { return 0 }
        return count
    }
    
    init(
        coordinator: AdditionalSignupCoordinatorProtocol,
        hashTagUsecase: HashtagUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.hashTagUsecase = hashTagUsecase
    }
    
    func transform(input: Input) -> Output {
        let collectionReloadObservable = PublishSubject<Void>()
        
        input.kindHashtag
            .subscribe { [weak self] in
                self?.loadTagList(kind: $0)
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .map { $0.row }
            .subscribe { [weak self] in
                print("선택..")
                self?.selectBadge(index: $0)
                self?.selectedHashtag.forEach {
                    print($0.hashtagTitle())
                }
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .subscribe(onNext: {
                // TODO: 분기처리 필요
                self.coordinator?.finish(success: true)
            })
            .disposed(by: disposeBag)
        
        badgeList
            .subscribe { _ in
                collectionReloadObservable.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(hashtagReload: collectionReloadObservable.asObservable())
    }
    
    private func loadTagList(kind: KindHashtag) {
        hashTagUsecase.loadTagList(kind: kind)
            .subscribe { [weak self] in
                self?.badgeList.onNext($0)
            }
            .disposed(by: disposeBag)
    }
    
    func cellInfo(index: Int) -> Hashtag? {
        return try? badgeList.value()[index]
    }
    
    func cellTitle(index: Int) -> String? {
        guard let list = try? badgeList.value() else { return nil }
        return list[index].hashtagTitle()
    }
    
    func isSelected(index: Int) -> Bool {
        guard let hashtag = try? badgeList.value()[index] else { return false }
        if selectedHashtag.contains(where: { $0.title == hashtag.title }) { return true }
        
        return false
    }
    
    func selectBadge(index: Int) {
        guard let hashTag = try? badgeList.value()[index] else { return }
        
        if !selectedHashtag.contains(where: { $0.title == hashTag.title }) {
            selectedHashtag.append(hashTag)
            print(selectedHashtag.count)
            return
        }
    }
    
    func deselectBadge(index: Int) {
        guard let hashTag = try? badgeList.value()[index] else { return }
        
        if let removeIndex = selectedHashtag.firstIndex(where: { $0.title == hashTag.title }) {
            selectedHashtag.remove(at: removeIndex)
            print(selectedHashtag.count)
        }
    }
}
