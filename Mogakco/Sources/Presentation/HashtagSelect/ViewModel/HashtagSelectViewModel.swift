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
    var selectedBadges: [String] = []
    let badgeList = BehaviorSubject<[String]>(value: [])
    let hashTagUsecase: HashtagUsecaseProtocol
    
    var collectionViewCount: Int {
        guard let count = try? badgeList.value().count else { return 0 }
        return count
    }
    
    init(coordinator: AdditionalSignupCoordinatorProtocol, hashTagUsecase: HashtagUsecaseProtocol) {
        self.coordinator = coordinator
        self.hashTagUsecase = hashTagUsecase
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
//        guard let selected = try? selectedBadges.value(),
//              let title else {
//            return false
//        }
        
        if let title {
            if selectedBadges.contains(title) { return true }
        }
        
        return false
    }
    
    func selectBadge(title: String) {
//        guard var selected = try? selectedBadges.value(),
//              !selected.contains(title) else {
//            return
//        }
        
        if !selectedBadges.contains(title) {
            selectedBadges.append(title)
            return
        }
    }
    
    func deselectBadge(title: String) {
//        guard var selected = try? selectedBadges.value(),
//              let removeIndex = selected.firstIndex(of: title) else {
//            return
//        }
        
        guard selectedBadges.contains(title),
              let removeIndex = selectedBadges.firstIndex(of: title) else {
            return
        }
        
        selectedBadges.remove(at: removeIndex)
    }
}
