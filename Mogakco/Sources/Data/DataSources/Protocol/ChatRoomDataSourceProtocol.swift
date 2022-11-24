//
//  ChatRoomDataSourceProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol ChatRoomDataSourceProtocol {
    func list() -> Observable<Documents<[ChatRoomResponseDTO]>>
    func chats(id: String) -> Observable<Documents<[ChatResponseDTO]>>
}
