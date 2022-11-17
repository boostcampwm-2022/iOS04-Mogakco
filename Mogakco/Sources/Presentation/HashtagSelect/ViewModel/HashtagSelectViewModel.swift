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

final class HashtagSelectViewModel: ViewModel {
    
    struct Input {
        let nextButtonTapped: Observable<Void>
    }
    struct Output {
        let collectionReloadObservable: Observable<Void>
    }
    
    weak var coordinator: AdditionalSignupCoordinatorProtocol?
    var disposeBag = DisposeBag()
    let selectedBadges = BehaviorSubject<[String]>(value: [])
    let badgeList = BehaviorSubject<[String]>(value: [])
    
    var collectionViewCount: Int {
        guard let count = try? badgeList.value().count else { return 0 }
        return count
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        let collectionReloadObservable = PublishSubject<Void>()
        
        input.nextButtonTapped
            .subscribe(onNext: {
                self.coordinator?.finish(success: true)
            })
            .disposed(by: disposeBag)
        
        badgeList
            .subscribe { _ in
                collectionReloadObservable.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(collectionReloadObservable: collectionReloadObservable.asObservable())
    }
    
    func cellTitle(index: Int) -> String {
        guard let list = try? badgeList.value() else { return "?" }
        return list[index]
    }
    
    func isSelected(title: String?) -> Bool {
        guard let selected = try? selectedBadges.value(),
                let title
        else { return false }
        if selected.contains(title) { return true }
        
        return false
    }
    
    func selectBadge(title: String) {
        guard var selected = try? selectedBadges.value(),
              !selected.contains(title)
        else { return }
        
        selected.append(title)
        selectedBadges.onNext(selected)
    }
    
    func deselectBadge(title: String) {
        guard var selected = try? selectedBadges.value(),
              let removeIndex = selected.firstIndex(of: title)
        else { return }
        
        selected.remove(at: removeIndex)
        selectedBadges.onNext(selected)
    }
}
