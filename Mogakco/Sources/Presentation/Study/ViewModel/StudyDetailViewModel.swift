//
//  StudyDetailViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class StudyDetailViewModel: ViewModel {
    
    struct Input {
        let studyJoinButtonTapped: Observable<Void>
    }
    
    struct Output {
        let studyDetail: Observable<Study>
        let languageReload: Observable<Void>
        let userReload: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let studyID: String
    private let coordinator: StudyTabCoordinatorProtocol
    private let studyUseCase: StudyDetailUseCaseProtocol
    private let hashtagUseCase: HashtagUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    private let joinStudyUseCase: JoinStudyUseCaseProtocol
    
    var languages = BehaviorSubject<[Hashtag]>(value: [])
    var participants = BehaviorSubject<[User]>(value: [])
    
    var languageCount: Int {
        return (try? languages.value().count) ?? 0
    }
    
    var participantsCount: Int {
        return (try? participants.value().count) ?? 0
    }
    
    init(
        studyID: String,
        coordinator: StudyTabCoordinatorProtocol,
        studyUsecase: StudyDetailUseCaseProtocol,
        hashtagUseCase: HashtagUseCaseProtocol,
        userUseCase: UserUseCaseProtocol,
        joinStudyUseCase: JoinStudyUseCase
    ) {
        self.studyID = studyID
        self.coordinator = coordinator
        self.studyUseCase = studyUsecase
        self.hashtagUseCase = hashtagUseCase
        self.userUseCase = userUseCase
        self.joinStudyUseCase = joinStudyUseCase
    }
    
    func transform(input: Input) -> Output {
        // TODO: 유저 UseCase에서 불러오기, 언어 불러오기 바인딩
        let languageReload = PublishSubject<Void>()
        let userReload = PublishSubject<Void>()
        let studyDetailLoad = PublishSubject<Study>()
        
        studyUseCase.study(id: studyID)
            .subscribe(onNext: {
                studyDetailLoad.onNext($0)
            })
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap {
                return $0.0.hashtagUseCase.loadHashtagByString(kind: .language, tagTitle: $0.1.languages)
            }
            .subscribe(onNext: { [weak self] in
                self?.languages.onNext($0)
            })
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap {
                return $0.0.userUseCase.users(ids: $0.1.userIDs)
            }
            .subscribe(
                onNext: { [weak self] in
                    self?.participants.onNext($0)
                }
            )
            .disposed(by: disposeBag)
        
        languages
            .subscribe(onNext: { _ in
                languageReload.onNext(())
            })
            .disposed(by: disposeBag)
        
        participants
            .subscribe(onNext: { _ in
                userReload.onNext(())
            })
            .disposed(by: disposeBag)
        
        input.studyJoinButtonTapped
            .withUnretained(self)
            .flatMap {
                $0.0.joinStudyUseCase.join(id: $0.0.studyID)
            }
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.coordinator.showChatDetail(chatRoomID: $0.0.studyID)
            }, onError: { error in
                // TODO: 채팅방 인원이 다 찼을 때 예외처리
                print("👀:", error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            studyDetail: studyDetailLoad,
            languageReload: languageReload.asObservable(),
            userReload: userReload.asObservable()
        )
    }
    
    func userSelect(index: Int) {
        // 
    }
    
    func languaegCellInfo(index: Int) -> Hashtag? {
        return try? languages.value()[index]
    }
    
    func  participantCellInfo(index: Int) -> User? {
        return try? participants.value()[index]
    }
}
