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

final class HashtagSelectViewModel: ViewModel {
    
    struct Input {}
    struct Output {
        let collectionReloadObservable: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let collectionReloadObservable = PublishSubject<Void>()
        
        badgeList
            .subscribe { _ in
                collectionReloadObservable.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(collectionReloadObservable: collectionReloadObservable.asObservable())
    }
    
    init(useCase: ) {
        badgeList.onNext(["swift", "javascript", "python", "Hello", "python", "python"])
    }
    
    var disposeBag = DisposeBag()
    let selectedBadges = BehaviorSubject<[String]>(value: [])
    let badgeList = BehaviorSubject<[String]>(value: [])
    
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
