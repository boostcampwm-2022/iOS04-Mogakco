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
        let isLoading: Driver<Bool>
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
    private let studyDetailLoad = PublishSubject<Study>()
    private let languages = BehaviorSubject<[Hashtag]>(value: [])
    private let participants = BehaviorSubject<[User]>(value: [])
    private let isLoading = BehaviorSubject(value: true)
    private let alert = PublishSubject<Alert>()
    private let report = PublishSubject<Bool>()

    func transform(input: Input) -> Output {
        bindStudyDetail()
        bindStudyJoin(input.studyJoinButtonTapped)
        bindParticipantCellTapped(input.selectParticipantCell)
        bindBackButton(input.backButtonTapped)
        bindReportButton(input.reportButtonTapped)
        
        Observable.combineLatest(studyDetailLoad, languages.skip(1), participants.skip(1))
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        return Output(
            studyDetail: studyDetailLoad,
            languages: languages.asDriver(onErrorJustReturn: []),
            participants: participants.asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            alert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
    
    private func bindStudyDetail() {
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
                    viewModel.participants.onNext(users)
                case .failure:
                    let alert = Alert(title: "유저 목록 로드 오류", message: "유저 목록 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindStudyJoin(_ studyJoinButtonTapped: Observable<Void>) {
        studyJoinButtonTapped
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
    }
    
    private func bindParticipantCellTapped(_ userCellTapped: Observable<User>) {
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
        
        Observable.combineLatest(userCellTapped, profile.compactMap { $0 })
            .subscribe(onNext: { [weak self] selectUser, profile in
                guard let self else { return }
                if selectUser.id == profile.id {
                    self.navigation.onNext(.profile(type: .current))
                } else {
                    self.navigation.onNext(.profile(type: .other(selectUser)))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBackButton(_ buttonTapped: Observable<Void>) {
        buttonTapped
            .map { StudyDetailNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    private func bindReportButton(_ buttonTapped: Observable<Void>) {
        buttonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                let alert = Alert(
                    title: "신고하기",
                    message: "확인 후 제재되며, 더 이상 해당 스터디에 참여할 수 없습니다.",
                    observer: viewModel.report.asObserver()
                )
                viewModel.alert.onNext(alert)
            })
            .disposed(by: disposeBag)
        
        report
            .filter { $0 }
            .withUnretained(self)
            .flatMap { $0.0.reportUseCase?.reportStudy(id: $0.0.studyID) ?? .empty() }
            .map { _ in StudyDetailNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
