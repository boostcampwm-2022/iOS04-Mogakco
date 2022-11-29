//
//  LeaveStudyUseCaseProtocol.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import RxSwift

protocol LeaveStudyUseCaseProtocol {
    func leaveStudy(id: String) -> Observable<Void>
}
