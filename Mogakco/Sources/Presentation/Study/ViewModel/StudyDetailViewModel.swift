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

enum StudyDetailNavigation {
    case chatRoom(id: String)
    case profile(type: ProfileType)
    case back
}

final class StudyDetailViewModel: ViewModel {
    
    struct Input {
        let studyJoinButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let studyDetail: Observable<Study>
        let languageReload: Observable<Void>
        let userReload: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let studyID: String
    private let studyUseCase: StudyDetailUseCaseProtocol
    private let hashtagUseCase: HashtagUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    private let joinStudyUseCase: JoinStudyUseCaseProtocol
    
    let navigation = PublishSubject<StudyDetailNavigation>()
    var languages = BehaviorSubject<[Hashtag]>(value: [])
    var participants = BehaviorSubject<[User]>(value: [])
    var languageCount: Int { (try? languages.value().count) ?? 0 }
    var participantsCount: Int { (try? participants.value().count) ?? 0 }
    
    init(
        studyID: String,
        studyUsecase: StudyDetailUseCaseProtocol,
        hashtagUseCase: HashtagUseCaseProtocol,
        userUseCase: UserUseCaseProtocol,
        joinStudyUseCase: JoinStudyUseCase
    ) {
        self.studyID = studyID
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
            .bind(to: studyDetailLoad)
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap {
                $0.0.hashtagUseCase.loadHashtagByString(
                    kind: .language,
                    tagTitle: $0.1.languages
                )
            }
            .bind(to: languages)
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap { $0.0.userUseCase.users(ids: $0.1.userIDs) }
            .bind(to: participants)
            .disposed(by: disposeBag)
        
        languages
            .map { _ in () }
            .bind(to: languageReload)
            .disposed(by: disposeBag)
        
        participants
            .map { _ in () }
            .bind(to: userReload)
            .disposed(by: disposeBag)
        
        input.studyJoinButtonTapped
            .withUnretained(self)
            .flatMap { $0.0.joinStudyUseCase.join(id: $0.0.studyID) }
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.navigation.onNext(.chatRoom(id: $0.0.studyID))
            }, onError: { error in
                print("👀:", error) // TODO: 채팅방 인원이 다 찼을 때 예외처리
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { StudyDetailNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            studyDetail: studyDetailLoad,
            languageReload: languageReload.asObservable(),
            userReload: userReload.asObservable()
        )
    }
    
    func userSelect(index: Int) {
        // 사용자 선택되었을 때 내 프로필 보여주기: navigation.onNext(.current)
        // 사용자 선택되었을 때 다른 프로필 보여주기: navigation.onNext(.other(user))
    }
    
    func languaegCellInfo(index: Int) -> Hashtag? {
        return try? languages.value()[index]
    }
    
    func  participantCellInfo(index: Int) -> User? {
        return try? participants.value()[index]
    }
}
