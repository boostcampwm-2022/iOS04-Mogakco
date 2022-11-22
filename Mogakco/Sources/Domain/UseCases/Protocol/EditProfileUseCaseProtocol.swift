//
//  EditProfileUseCaseProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

protocol EditProfileUseCaseProtocol {
    func editProfile(name: String, introduce: String) -> Observable<Void>
}
