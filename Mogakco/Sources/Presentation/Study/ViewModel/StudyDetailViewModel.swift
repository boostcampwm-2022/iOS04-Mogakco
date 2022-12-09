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
        let selectParticipantCell: Observable<User>
        let backButtonTapped: Observable<Void>
        let reportButtonTapped: Observable<Void>
    }
    
    struct Output {
        let studyDetail: Observable<Study>
        let languages: Driver<[Hashtag]>
        let participants: Driver<[User]>
        let alert: Signal<Alert>
    }
    
    var disposeBag = DisposeBag()
    var studyID: String = ""
    var studyDetailUseCase: StudyDetailUseCaseProtocol?
    var hashtagUseCase: HashtagUseCaseProtocol?
    var userUseCase: UserUseCaseProtocol?
    var joinStudyUseCase: JoinStudyUseCaseProtocol?
    var reportUseCase: ReportUseCaseProtocol?
    let navigation = PublishSubject<StudyDetailNavigation>()
    var languages = BehaviorSubject<[Hashtag]>(value: [])
    var participants = BehaviorSubject<[User]>(value: [])
    var languageCount: Int { (try? languages.value().count) ?? 0 }
    var participantsCount: Int { (try? participants.value().count) ?? 0 }
    private let alert = PublishSubject<Alert>()

    func transform(input: Input) -> Output {
        let studyDetailLoad = PublishSubject<Study>()
        let languages = BehaviorSubject<[Hashtag]>(value: [])
        let participants = BehaviorSubject<[User]>(value: [])
        
        studyDetailUseCase?.study(id: studyID)
            .bind(to: studyDetailLoad)
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap {
                $0.0.hashtagUseCase?.loadHashtagByString(
                    kind: .language,
                    tagTitle: $0.1.languages
                ) ?? .empty()
            }
            .bind(to: languages)
            .disposed(by: disposeBag)
        
        studyDetailLoad
            .withUnretained(self)
            .flatMap { $0.0.userUseCase?.users(ids: $0.1.userIDs).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let users):
                    participants.onNext(users)
                case .failure:
                    let alert = Alert(title: "유저 목록 로드 오류", message: "유저 목록 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)

        input.studyJoinButtonTapped
            .withUnretained(self)
            .flatMap { $0.0.joinStudyUseCase?.join(id: $0.0.studyID).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.navigation.onNext(.chatRoom(id: viewModel.studyID)) // 응답 chatRoomID 값으로 바꾸는게 더 정확할듯
                case .failure:
                    let alert = Alert(title: "스터디 참여 오류", message: "스터디 참여 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        let profile = BehaviorSubject<User?>(value: nil)
        
        (userUseCase?.myProfile().asResult() ?? .empty())
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let user):
                    profile.onNext(user)
                case .failure:
                    let alert = Alert(title: "유저 정보 로드 오류", message: "유저 정보 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(input.selectParticipantCell, profile.compactMap { $0 })
            .subscribe(onNext: { [weak self] selectUser, profile in
                guard let self else { return }
                if selectUser.id == profile.id {
                    self.navigation.onNext(.profile(type: .current))
                } else {
                    self.navigation.onNext(.profile(type: .other(selectUser)))
                }
            })
            .disposed(by: disposeBag)
        
//        if let userUseCase {
//            Observable.combineLatest(input.selectParticipantCell, userUseCase.myProfile())
//                .map { ($0.0.row, $0.1) }
//                .map { (try? participants.value()[$0.0], $0.1) }
//                .withUnretained(self)
//                .subscribe {
//                    let user = $0.1.0
//                    if $0.1.0?.id == $0.1.1.id {
//                        $0.0.navigation.onNext(.profile(type: .current))
//                    } else {
//                        guard let other = $0.1.0 else { return }
//                        $0.0.navigation.onNext(.profile(type: .other(other)))
//                    }
//                }
//                .disposed(by: disposeBag)
//        }
        
        input.backButtonTapped
            .map { StudyDetailNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.reportButtonTapped
            .withUnretained(self)
            .flatMap { $0.0.reportUseCase?.reportStudy(id: $0.0.studyID) ?? .empty() }
            .map { _ in StudyDetailNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            studyDetail: studyDetailLoad,
            languages: languages.asDriver(onErrorJustReturn: []),
            participants: participants.asDriver(onErrorJustReturn: []),
            alert: alert.asSignal(onErrorSignalWith: .empty())
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
