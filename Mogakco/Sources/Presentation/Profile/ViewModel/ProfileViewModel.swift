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

    var disposeBag = DisposeBag()
    private let type: ProfileType
    private weak var coordinator: ProfileTabCoordinatorProtocol?
    private let userUseCase: UserUseCase
    private let createChatRoomUseCase: CreateChatRoomUseCase?
    private let user = BehaviorSubject<User?>(value: nil)
    private let studyRatingList = BehaviorSubject<[(String, Int)]>(value: [])
 
    init(
        type: ProfileType,
        coordinator: ProfileTabCoordinatorProtocol,
        userUseCase: UserUseCase,
        createChatRoomUseCase: CreateChatRoomUseCase?
    ) {
        self.type = type
        self.coordinator = coordinator
        self.userUseCase = userUseCase
        self.createChatRoomUseCase = createChatRoomUseCase
    }
    
    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindScene(input: input)

        return Output(
            isMyProfile: Driver.just(type).map { $0 == .current },
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
                .compactMap { $0?.languages }
                .map { $0.compactMap { Career.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            categorys: user
                .compactMap { $0?.languages }
                .map { $0.compactMap { Category.idToHashtag(id: $0) } }
                .asDriver(onErrorJustReturn: []),
            studyRatingList: studyRatingList.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func bindUser(input: Input) {
        input.viewWillAppear
            .filter { self.type == ProfileType.current }
            .withUnretained(self)
            .flatMap { $0.0.userUseCase.myProfile() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.user.onNext(user)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .compactMap {
                switch self.type {
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
            .flatMap { $0.0.userUseCase.studyRatingList(studyIDs: $0.1) }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, studyRatingList in
                viewModel.studyRatingList.onNext(studyRatingList)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindScene(input: Input) {
        input.editProfileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.coordinator?.showEditProfile()
            })
            .disposed(by: disposeBag)
        
        input.chatButtonTapped
            .withLatestFrom(user.compactMap { $0 })
            .compactMap { [weak self] in self?.createChatRoomUseCase?.create(otherUser: $0) }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] chatRoom in
                self?.coordinator?.showChatDetail(chatRoomID: chatRoom.id)
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
