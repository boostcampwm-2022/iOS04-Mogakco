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
        container.register(AuthServiceProtocol.self) { _ in FBAuthService() }
        container.register(RemoteUserDataSourceProtocol.self) { _ in RemoteUserDataSource() }
        container.register(StudyDataSourceProtocol.self) { _ in StudyDataSource() }
        container.register(ChatRoomDataSourceProtocol.self) { _ in ChatRoomDataSource() }
        container.register(ChatDataSourceProtocol.self) { _ in ChatDataSource() }
        container.register(HashtagDataSourceProtocol.self) { _ in HashtagDataSource() }
        container.register(ReportDataSourceProtocol.self) { _ in ReportDataSource() }
        container.register(KeychainProtocol.self) { _ in Keychain() }
        container.register(KeychainManagerProtocol.self) { resolver in
            var dataSource = KeychainManager()
            dataSource.keychain = resolver.resolve(KeychainProtocol.self)
            return dataSource
        }
        container.register(PushNotificationServiceProtocol.self) { _ in PushNotificationService() }
    }
    
    private func registerRepositories() {
        container.register(TokenRepositoryProtocol.self) { resolver in
            var repository = TokenRepository()
            repository.keychainManager = resolver.resolve(KeychainManagerProtocol.self)
            return repository
        }
        container.register(AuthRepositoryProtocol.self) { resolver in
            var repository = AuthRepository()
            repository.authService = resolver.resolve(AuthServiceProtocol.self)
            
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            repository.chatRoomDataSource = resolver.resolve(ChatRoomDataSourceProtocol.self)
            repository.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return repository
        }
        container.register(ChatRepositoryProtocol.self) { resolver in
            var repository = ChatRepository()
            repository.chatDataSource = resolver.resolve(ChatDataSourceProtocol.self)
            repository.reportDataSource = resolver.resolve(ReportDataSourceProtocol.self)
            repository.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return repository
        }
        container.register(ChatRoomRepositoryProtocol.self) { resolver in
            var repository = ChatRoomRepository()
            repository.chatRoomDataSource = resolver.resolve(ChatRoomDataSourceProtocol.self)
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            repository.studyDataSource = resolver.resolve(StudyDataSourceProtocol.self)
            repository.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
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
            repository.reportDataSource = resolver.resolve(ReportDataSourceProtocol.self)
            repository.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return repository
        }
        container.register(UserRepositoryProtocol.self) { resolver in
            var repository = UserRepository()
            repository.remoteUserDataSource = resolver.resolve(RemoteUserDataSourceProtocol.self)
            repository.keyChainManager = resolver.resolve(KeychainManagerProtocol.self)
            return repository
        }
        container.register(ReportRepositoryProtocol.self) { resolver in
            var repository = ReportRepository()
            repository.reportDataSource = resolver.resolve(ReportDataSourceProtocol.self)
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(AutoLoginUseCaseProtocol.self) { resolver in
            var useCase = AutoLoginUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
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
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
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
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        container.register(LeaveStudyUseCaseProtocol.self) { resolver in
            var useCase = LeaveStudyUseCase()
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
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
        container.register(WithdrawUseCaseProtocol.self) { resolver in
            var useCase = WithdrawUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.studyRepository = resolver.resolve(StudyRepositoryProtocol.self)
            useCase.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return useCase
        }
        container.register(ReportUseCaseProtocol.self) { resolver in
            var useCase = ReportUseCase()
            useCase.reportRepository = resolver.resolve(ReportRepositoryProtocol.self)
            return useCase
        }
        container.register(LogoutUseCaseProtocol.self) { resolver in
            var useCase = LogoutUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return useCase
        }
        container.register(SubscribePushNotificationUseCaseProtocol.self) { resolver in
            var useCase = SubscribePushNotificationUseCase()
            useCase.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return useCase
        }
        container.register(UnsubscribePushNotificationUseCaseProtocol.self) { resolver in
            var useCase = UnsubscribePushNotificationUseCase()
            useCase.pushNotificationService = resolver.resolve(PushNotificationServiceProtocol.self)
            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(ChatViewModel.self) { resolver in
            let viewModel = ChatViewModel()
            viewModel.chatUseCase = resolver.resolve(ChatUseCaseProtocol.self)
            viewModel.leaveStudyUseCase = resolver.resolve(LeaveStudyUseCaseProtocol.self)
            viewModel.subscribePushNotificationUseCase = resolver.resolve(SubscribePushNotificationUseCaseProtocol.self)
            viewModel.unsubscribePushNotificationUseCase = resolver.resolve(UnsubscribePushNotificationUseCaseProtocol.self)
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
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            viewModel.autoLoginUseCase = resolver.resolve(AutoLoginUseCaseProtocol.self)
            viewModel.loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)
            return viewModel
        }
        container.register(SetPasswordViewModel.self) { _ in
            let viewModel = SetPasswordViewModel()
            return viewModel
        }
        container.register(PolicyViewModel.self) { _ in
            let viewModel = PolicyViewModel()
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
            viewModel.reportUseCase = resolver.resolve(ReportUseCaseProtocol.self)
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
        container.register(ProfileViewModel.self) { resolver in
            let viewModel = ProfileViewModel()
            viewModel.userUseCase = resolver.resolve(UserUseCaseProtocol.self)
            viewModel.createChatRoomUseCase = resolver.resolve(CreateChatRoomUseCaseProtocol.self)
            viewModel.reportUseCase = resolver.resolve(ReportUseCaseProtocol.self)
            return viewModel
        }
        container.register(CreateStudyViewModel.self) { resolver in
            let viewModel = CreateStudyViewModel()
            viewModel.createStudyUseCase = resolver.resolve(CreateStudyUseCaseProtocol.self)
            return viewModel
        }
        container.register(SelectStudySortViewModel.self) { _ in SelectStudySortViewModel()
        }
        container.register(WithdrawViewModel.self) { resolver in
            let viewModel = WithdrawViewModel()
            viewModel.withdrawUseCase = resolver.resolve(WithdrawUseCaseProtocol.self)
            return viewModel
        }
        container.register(SettingViewModel.self) { resolver in
            let viewModel = SettingViewModel()
            viewModel.logoutUseCase = resolver.resolve(LogoutUseCaseProtocol.self)
            return viewModel
        }
    }
}
