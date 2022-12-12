//
//  AuthRepository.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

struct AuthRepository: AuthRepositoryProtocol {
    
    var authService: AuthServiceProtocol?
    var remoteUserDataSource: RemoteUserDataSourceProtocol?
    var chatRoomDataSource: ChatRoomDataSourceProtocol?
    var pushNotificationService: PushNotificationServiceProtocol?
    private let disposeBag = DisposeBag()
    
    func signup(signupProps: SignupProps) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(signupProps: signupProps)
        return authService?.signup(request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func login(emailLogin: EmailLogin) -> Observable<Authorization> {
        let request = EmailAuthorizationRequestDTO(emailLogin: emailLogin)
        return (authService?.login(request) ?? .empty())       // 로그인
            .map { $0.toDomain() }
            .flatMap { authorization in  // 유저 채팅방 푸쉬 알림 구독
                return (remoteUserDataSource?.user(id: authorization.localId) ?? .empty())
                    .map { $0.toDomain() }
                    .map { $0.chatRoomIDs }
                    .flatMap { chatRoomIDs in
                        guard !chatRoomIDs.isEmpty else {
                            return Observable.just(())
                        }
                        return (chatRoomDataSource?.list() ?? .empty())
                            .map { $0.documents.map { $0.toDomain() } }
                            .map { $0.filter { chatRoomIDs.contains($0.id) } }
                            .flatMap { chatRooms in
                                return Observable.combineLatest(chatRooms.map {
                                    pushNotificationService?.subscribeTopic(topic: $0.id) ?? .empty()
                                })
                            }
                            .map { _ in () }
                    }
                    .map { _ in authorization }
            }
    }
}
