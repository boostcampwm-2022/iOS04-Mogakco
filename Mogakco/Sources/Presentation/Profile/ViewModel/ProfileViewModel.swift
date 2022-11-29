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

final class ProfileViewModel: ViewModel {
    
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
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let editProfileButtonTapped: Observable<Void>
        let chatButtonTapped: Observable<Void>
        let hashtagEditButtonTapped: Observable<KindHashtag>
    }
    
    struct Output {
        let isMyProfile: Observable<Bool>
        let profileImageURL: Observable<URL>
        let representativeLanguageImage: Observable<UIImage>
        let name: Observable<String>
        let introduce: Observable<String>
        let languages: Observable<[Hashtag]>
        let careers: Observable<[Hashtag]>
        let categorys: Observable<[Hashtag]>
        let studyRatingList: Observable<[(String, Int)]>
    }

    var disposeBag = DisposeBag()
    private let type: ProfileType
    private weak var coordinator: ProfileTabCoordinatorProtocol?
    private let userUseCase: UserUseCase
 
    init(
        type: ProfileType,
        coordinator: ProfileTabCoordinatorProtocol,
        userUseCase: UserUseCase
    ) {
        self.type = type
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        bindScene(input: input)
        
        let type = BehaviorSubject<ProfileType>(value: type)
        let isMyProfile = type
            .map { $0 == .current }
        let user = input.viewWillAppear
            .withLatestFrom(type)
            .withUnretained(self)
            .flatMap { viewModel, type -> Observable<User> in
                switch type {
                case .current:
                    return viewModel.userUseCase.myProfile()
                case let .other(user):
                    return viewModel.userUseCase.user(id: user.id)
                }
            }
        let studyRatingList = user
            .map { $0.studyIDs }
            .withUnretained(self)
            .flatMap { $0.0.userUseCase.studyRatingList(studyIDs: $0.1) }

        return Output(
            isMyProfile: isMyProfile.asObservable(),
            profileImageURL: user
                .compactMap { $0.profileImageURLString }
                .compactMap { URL(string: $0) },
            representativeLanguageImage: user
                .compactMap { $0.languages.randomElement() }
                .compactMap { UIImage(named: $0) },
            name: user.map { $0.name }.asObservable(),
            introduce: user.map { $0.introduce }.asObservable(),
            languages: user
                .map { $0.languages }
                .map { $0.compactMap { Languages.idToHashtag(id: $0) } }
                .asObservable(),
            careers: user
                .map { $0.languages }
                .map { $0.compactMap { Career.idToHashtag(id: $0) } }
                .asObservable(),
            categorys: user
                .map { $0.languages }
                .map { $0.compactMap { Category.idToHashtag(id: $0) } }
                .asObservable(),
            studyRatingList: studyRatingList.asObservable()
        )
    }
    
    private func bindScene(input: Input) {
        input.editProfileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showEditProfile()
            })
            .disposed(by: disposeBag)
        
        input.chatButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showChat()
            })
            .disposed(by: disposeBag)
        
        input.hashtagEditButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, kindHashtag in
                viewModel.coordinator?.showSelectHashtag(kindHashtag: kindHashtag)
            })
            .disposed(by: disposeBag)
    }
}
