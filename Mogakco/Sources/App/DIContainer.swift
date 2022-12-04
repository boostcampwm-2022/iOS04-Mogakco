//
//  DependencyInjector.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/04.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    let container = Container()
    private init() {}
    
    func inject() {
        registerDataSources()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private func registerDataSources() {
        let provider = Provider.default
        container.register(AuthServiceProtocol.self) { _ in FBAuthService(provider: provider) }
        container.register(RemoteUserDataSourceProtocol.self) { _ in RemoteUserDataSource(provider: provider) }
        container.register(LocalUserDataSourceProtocol.self) { _ in UserDefaultsUserDataSource() }
        container.register(StudyDataSourceProtocol.self) { _ in StudyDataSource(provider: provider) }
        container.register(ChatRoomDataSourceProtocol.self) { _ in ChatRoomDataSource(provider: provider) }
        container.register(ChatRoomDataSourceProtocol.self) { _ in ChatRoomDataSource(provider: provider) }
        container.register(HashtagDataSourceProtocol.self) { _ in HashtagDataSource() }
        container.register(KeychainProtocol.self) { _ in Keychain() }
        container.register(KeychainManagerProtocol.self) { _ in KeychainManager() }
    }
    
    private func registerRepositories() {
        container.register(TokenRepositoryProtocol.self) { resolver in
            var repository = TokenRepository()
            repository.keychainManager = resolver.resolve(KeychainManager.self)
            return repository
        }
        container.register(AuthRepositoryProtocol.self) { resolver in
            var repository = AuthRepository()
            repository.authService = resolver.resolve(AuthServiceProtocol.self)
            return repository
        }
        container.register(ChatRepositoryProtocol.self) { resolver in
            var repository = ChatRepository()
            repository.chatDataSource = resolver.resolve(ChatDataSourceProtocol.self)
            return repository
        }
        container.register(ChatRoomRepositoryProtocol.self) { resolver in
            var repository = ChatRoomRepository()
            repository.chatRoomDataSource = resolver.resolve(ChatRoomDataSourceProtocol.self)
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            repository.studyDataSource = resolver.resolve(StudyDataSourceProtocol.self)
            return repository
        }
        container.register(HashtagRepositoryProtocol.self) { resolver in
            var repository = HashtagRepository()
            repository.localHashtagDataSource = resolver.resolve(HashtagDataSourceProtocol.self)
            return repository
        }
        container.register(StudyRepositoryProtocol.self) { resolver in
            var repository = StudyRepository()
            repository.studyDataSource = resolver.resolve(StudyDataSourceProtocol.self)
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            repository.chatRoomDataSource = resolver.resolve(ChatRoomDataSourceProtocol.self)
            repository.localUserDataSource = resolver.resolve(LocalUserDataSourceProtocol.self)
            return repository
        }
        container.register(UserRepositoryProtocol.self) { resolver in
            var repository = UserRepository()
            repository.localUserDataSource = resolver.resolve(LocalUserDataSourceProtocol.self)
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(AutoLoginUseCaseProtocol.self) { resolver in
            var useCase = AutoLoginUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        container.register(ChatUseCaseProtocol.self) { resolver in
            var useCase = ChatUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.chatRepository = resolver.resolve(ChatRepositoryProtocol.self)
            return useCase
        }
        container.register(ChatRoomListUseCaseProtocol.self) { resolver in
            var useCase = ChatRoomListUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.chatRoomRepository = resolver.resolve(ChatRoomRepositoryProtocol.self)
            return useCase
        }
        container.register(CreateChatRoomUseCaseProtocol.self) { resolver in
            var useCase = CreateChatRoomUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.chatRoomRepository = resolver.resolve(ChatRoomRepositoryProtocol.self)
            return useCase
        }
        container.register(CreateStudyUseCaseProtocol.self) { resolver in
            var useCase = CreateStudyUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepository.self)
            return useCase
        }
        container.register(EditProfileUseCaseProtocol.self) { resolver in
            var useCase = EditProfileUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        container.register(HashtagUseCaseProtocol.self) { resolver in
            var useCase = HashtagUseCase()
            useCase.hashtagRepository = resolver.resolve(HashtagRepositoryProtocol.self)
            return useCase
        }
        container.register(JoinStudyUseCaseProtocol.self) { resolver in
            var useCase = JoinStudyUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            return useCase
        }
        container.register(LeaveStudyUseCaseProtocol.self) { resolver in
            var useCase = LeaveStudyUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            return useCase
        }
        container.register(LoginUseCaseProtocol.self) { resolver in
            var useCase = LoginUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.authRepository = resolver.resolve(AuthRepositoryProtocol.self)
            return useCase
        }
        container.register(ProfileUseCaseProtocol.self) { resolver in
            var useCase = ProfileUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        container.register(SignupUseCaseProtocol.self) { resolver in
            var useCase = SignupUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.authRepository = resolver.resolve(AuthRepositoryProtocol.self)
            return useCase
        }
        container.register(StudyDetailUseCaseProtocol.self) { resolver in
            var useCase = StudyDetailUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            return useCase
        }
        container.register(StudyListUseCaseProtocol.self) { resolver in
            var useCase = StudyListUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            return useCase
        }
        container.register(UserUseCaseProtocol.self) { resolver in
            var useCase = UserUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(ChatViewModel.self) { resolver in
            let viewModel = ChatViewModel()
            viewModel.chatUseCase = resolver.resolve(ChatUseCaseProtocol.self)
            viewModel.leaveStudyUseCase = resolver.resolve(LeaveStudyUseCaseProtocol.self)
            return viewModel
        }
        container.register(ChatListViewModel.self) { resolver in
            let viewModel = ChatListViewModel()
            viewModel.chatRoomListUseCase = resolver.resolve(ChatRoomListUseCaseProtocol.self)
            return viewModel
        }
        container.register(SetEmailViewModel.self) { _ in
            let viewModel = SetEmailViewModel()
            return viewModel
        }
        container.register(LaunchScreenViewModel.self) { resolver in
            let viewModel = LaunchScreenViewModel()
            viewModel.autoLoginUseCase = resolver.resolve(AutoLoginUseCaseProtocol.self)
            return viewModel
        }
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            viewModel.loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)
            return viewModel
        }
        container.register(SetPasswordViewModel.self) { _ in
            let viewModel = SetPasswordViewModel()
            return viewModel
        }
        container.register(HashtagEditViewModel.self) { resolver in
            let viewModel = HashtagEditViewModel()
            viewModel.hashTagUsecase = resolver.resolve(HashtagUseCaseProtocol.self)
            viewModel.editProfileUseCase = resolver.resolve(EditProfileUseCaseProtocol.self)
            return viewModel
        }
        container.register(HashtagSelectedViewModel.self) { resolver in
            let viewModel = HashtagSelectedViewModel()
            viewModel.hashTagUsecase = resolver.resolve(HashtagUseCaseProtocol.self)
            viewModel.signUseCase = resolver.resolve(SignupUseCaseProtocol.self)
            return viewModel
        }
        container.register(EditProfileViewModel.self) { resolver in
            let viewModel = EditProfileViewModel()
            viewModel.editProfileUseCase = resolver.resolve(EditProfileUseCaseProtocol.self)
            viewModel.profileUseCase = resolver.resolve(ProfileUseCaseProtocol.self)
            return viewModel
        }
        container.register(StudyDetailViewModel.self) { resolver in
            let viewModel = StudyDetailViewModel()
            viewModel.userUseCase = resolver.resolve(UserUseCaseProtocol.self)
            viewModel.studyDetailUseCase = resolver.resolve(StudyDetailUseCaseProtocol.self)
            viewModel.hashtagUseCase = resolver.resolve(HashtagUseCaseProtocol.self)
            viewModel.joinStudyUseCase = resolver.resolve(JoinStudyUseCaseProtocol.self)
            return viewModel
        }
        container.register(StudyListViewModel.self) { resolver in
            let viewModel = StudyListViewModel()
            viewModel.studyListUseCase = resolver.resolve(StudyListUseCaseProtocol.self)
            return viewModel
        }
        container.register(HashtagFilterViewModel.self) { resolver in
            let viewModel = HashtagFilterViewModel()
            viewModel.hashTagUsecase = resolver.resolve(HashtagUseCaseProtocol.self)
            return viewModel
        }
        
        
    }
}
