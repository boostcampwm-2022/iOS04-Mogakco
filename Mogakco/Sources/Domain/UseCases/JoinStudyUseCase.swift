//
//  JoinStudyUseCase.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

struct JoinStudyUseCase: JoinStudyUseCaseProtocol {
    
    enum JoinStudyUseCaseError: Error, LocalizedError {
        case max
    }
    
    var studyRepository: StudyRepositoryProtocol?
    private let disposeBag = DisposeBag()

    func join(id: String) -> Observable<Void> {
        return Observable<Void>.create { emitter in
            studyRepository?.join(id: id)
                .subscribe(onNext: {
                    emitter.onNext($0)
                }, onError: { _ in
                    emitter.onError(JoinStudyUseCaseError.max)
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
