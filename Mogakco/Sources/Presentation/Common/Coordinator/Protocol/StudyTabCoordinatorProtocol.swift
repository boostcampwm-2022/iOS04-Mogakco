//
//  StudyTabCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol StudyTabCoordinatorProtocol: AnyObject {
    func showStudyList()
    func showStudyDetail()
    func showStudyCreate()
    func showChatDetail()
    func showCategorySelect(delegate: HashtagSelectProtocol?)
    func showLanguageSelect(delegate: HashtagSelectProtocol?)
    func goToPrevScreen()
}
