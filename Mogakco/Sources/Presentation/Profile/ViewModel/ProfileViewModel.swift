//
//  ProfileViewModel.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum ProfileNavigation {
    case editProfile
    case editHashtag(kind: KindHashtag, selectedHashtags: [Hashtag])
    case chatRoom(id: String)
    case setting
    case back
}

enum ProfileType: Equatable {
    case current
    case other(User)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.current, .current), (.other, .other):
            return true
        default:
            return false
        }
    }
}

final class ProfileViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let editProfileButtonTapped: Observable<Void>
        let chatButtonTapped: Observable<Void>
        let hashtagEditButtonTapped: Observable<KindHashtag>
        let settingButtonTapped: Observable<Void>
        let reportButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isMyProfile: Driver<Bool>
        let profileImageURL: Observable<URL>
        let representativeLanguageImage: Observable<UIImage>
        let name: Driver<String>
        let introduce: Driver<String>
        let languages: Driver<[Hashtag]>
        let careers: Driver<[Hashtag]>
        let categorys: Driver<[Hashtag]>
        let studyRatingList: Driver<[(String, Int)]>
        let isLoading: Driver<Bool>
        let alert: Signal<Alert>
        let navigationBarHidden: Signal<Bool>
    }
    
    var userUseCase: UserUseCaseProtocol?
    var createChatRoomUseCase: CreateChatRoomUseCaseProtocol?
    var reportUseCase: ReportUseCaseProtocol?
    let navigation = PublishSubject<ProfileNavigation>()
    var disposeBag = DisposeBag()
    let type = BehaviorSubject<ProfileType>(value: .current)
    let navigationBarHidden = BehaviorSubject<Bool>(value: false)
    private let user = BehaviorSubject<User?>(value: nil)
    private let studyRatingList = BehaviorSubject<[(String, Int)]>(value: [])
    private let isLoading = BehaviorSubject(value: true)
    private let alert = PublishSubject<Alert>()
    
    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindScene(input: input)
        bindEndLoading()
        
        return Output(
            isMyProfile: type.map { $0 == .current }.asDriver(onErrorJustReturn: false),
            profileImageURL: user
                .compactMap { $0?.profileImageURLString }
                .compactMap { URL(string: $0) },
            representativeLanguageImage: user
                .compactMap { $0?.languages.randomElement() }
                .compactMap { UIImage(named: $0) },
            name: user.compactMap { $0?.name }.asDriver(onErrorJustReturn: ""),
            introduce: user.compactMap { $0?.introduce }.asDriver(onErrorJustReturn: ""),
            languages: user
                .compactMap { $0?.languages }
                .map { $0.compactMap { Language.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            careers: user
                .compactMap { $0?.careers }
                .map { $0.compactMap { Career.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            categorys: user
                .compactMap { $0?.categorys }
                .map { $0.compactMap { Category.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            studyRatingList: studyRatingList.asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            alert: alert.asSignal(onErrorSignalWith: .empty()),
            navigationBarHidden: navigationBarHidden.asSignal(onErrorJustReturn: false)
        )
    }
    
    private func bindEndLoading() {
        Observable
            .combineLatest(user.skip(1), studyRatingList.skip(1))
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
    }
    
    private func bindUser(input: Input) {
        input.viewWillAppear
            .withLatestFrom(type)
            .filter { $0 == ProfileType.current }
            .withUnretained(self)
            .flatMap { $0.0.userUseCase?.myProfile().asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let user):
                    viewModel.user.onNext(user)
                case .failure:
                    let alert = Alert(title: "프로필 로드 오류", message: "프로필 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(type)
            .compactMap { type in
                switch type {
                case .current:
                    return nil
                case let .other(user):
                    return user
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.user.onNext(user)
            })
            .disposed(by: disposeBag)
        
        user
            .compactMap { $0?.studyIDs }
            .withUnretained(self)
            .flatMap { $0.0.userUseCase?.studyRatingList(studyIDs: $0.1).asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let studyRatingList):
                    viewModel.studyRatingList.onNext(studyRatingList)
                case .failure:
                    let alert = Alert(title: "스터디 로드 오류", message: "스터디 Top3 로드 오류가 발생했어요! 다시 시도해주세요", observer: nil)
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindScene(input: Input) {
        input.editProfileButtonTapped
            .map { .editProfile }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.editProfileButtonTapped
            .map { .editProfile }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.chatButtonTapped
            .withLatestFrom(user.compactMap { $0 })
            .flatMap { [weak self] in self?.createChatRoomUseCase?.create(otherUser: $0) ?? .empty() }
            .map { .chatRoom(id: $0.id) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.hashtagEditButtonTapped
            .withLatestFrom(user.compactMap { $0 }) { ($0, $1) }
            .map { type, user -> (KindHashtag, [Hashtag]) in
                switch type {
                case .language:
                    return (type, user.languages.compactMap { Language(rawValue: $0) })
                case .career:
                    return (type, user.careers.compactMap { Career(rawValue: $0) })
                case .category:
                    return (type, user.categorys.compactMap { Category(rawValue: $0) })
                }
            }
            .map { .editHashtag(kind: $0.0, selectedHashtags: $0.1) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.settingButtonTapped
            .map { .setting }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.reportButtonTapped
            .withLatestFrom(user)
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { $0.0.reportUseCase?.reportUser(id: $0.1.id) ?? .empty() }
            .map { _ in .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
