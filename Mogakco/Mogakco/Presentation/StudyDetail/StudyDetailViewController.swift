//
//  StudyDetailViewController.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit
import SnapKit
import Then

final class StudyDetailViewController: UIViewController {
    
    private lazy var studyTitleLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.text = "스터디"
    }
    
}
