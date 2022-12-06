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
    case editHashtag(kind: KindHashtag)
    case chatRoom(id: String)
    case setting(email: String)
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
    }
    
    struct Output {
        let isMyProfile: Driver<Bool>
        let profileImageURL: Driver<URL>
        let representativeLanguageImage: Driver<UIImage>
        let name: Driver<String>
        let introduce: Driver<String>
        let languages: Driver<[Hashtag]>
        let careers: Driver<[Hashtag]>
        let categorys: Driver<[Hashtag]>
        let studyRatingList: Driver<[(String, Int)]>
    }

    var userUseCase: UserUseCaseProtocol?
    var createChatRoomUseCase: CreateChatRoomUseCaseProtocol?
    var reportUseCase: ReportUseCaseProtocol?
    let navigation = PublishSubject<ProfileNavigation>()
    var disposeBag = DisposeBag()
    let type = BehaviorSubject<ProfileType>(value: .current)
    private let user = BehaviorSubject<User?>(value: nil)
    private let studyRatingList = BehaviorSubject<[(String, Int)]>(value: [])

    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindScene(input: input)

        return Output(
            isMyProfile: type.map { $0 == .current }.asDriver(onErrorJustReturn: false),
            profileImageURL: user
                .compactMap { $0?.profileImageURLString }
                .compactMap { URL(string: $0) }
                .asDriver(onErrorDriveWith: .empty()),
            representativeLanguageImage: user
                .compactMap { $0?.languages.randomElement() }
                .compactMap { UIImage(named: $0) }
                .asDriver(onErrorDriveWith: .empty()),
            name: user.compactMap { $0?.name }.asDriver(onErrorJustReturn: ""),
            introduce: user.compactMap { $0?.introduce }.asDriver(onErrorJustReturn: ""),
            languages: user
                .compactMap { $0?.languages }
                .map { $0.compactMap { Languages.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            careers: user
                .compactMap { $0?.careers }
                .map { $0.compactMap { Career.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            categorys: user
                .compactMap { $0?.categorys }
                .map { $0.compactMap { Category.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            studyRatingList: studyRatingList.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func bindUser(input: Input) {
        input.viewWillAppear
            .withLatestFrom(type)
            .filter { $0 == ProfileType.current }
            .withUnretained(self)
            .flatMap { $0.0.userUseCase?.myProfile() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.user.onNext(user)
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
            .flatMap { $0.0.userUseCase?.studyRatingList(studyIDs: $0.1) ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, studyRatingList in
                viewModel.studyRatingList.onNext(studyRatingList)
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
            .map { .editHashtag(kind: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.settingButtonTapped
            .withLatestFrom(user)
            .compactMap { $0 }
            .map { .setting(email: $0.email) }
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
    }
}
