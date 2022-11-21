//
//  HashtagUsecaseProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol HashtagUseCaseProtocol {
    func loadTagList(kind: KindHashtag) -> Observable<[Languages]>
}
