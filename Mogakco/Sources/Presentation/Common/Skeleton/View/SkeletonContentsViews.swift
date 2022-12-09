//
//  SkeletonContentsViews.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

class SkeletonContentsBase: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class StudyListSkeletonContentsView: SkeletonContentsBase {}
final class ChatRoomListSkeletonContentsView: SkeletonContentsBase {}
final class StudyDetailSkeletonContentsView: SkeletonContentsBase {}
final class UserProfileSkeletonContentsView: SkeletonContentsBase {}
