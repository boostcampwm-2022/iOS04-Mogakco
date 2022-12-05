//
//  ChatSidebarView.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/19.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

enum ChatSidebarMenu: String, CaseIterable {
    
    case studyInfo = "스터디 정보"
    case exitStudy = "나가기"
    case showMember = "멤버 보기"

    init(row: Int) {
        switch row {
        case 0: self = .studyInfo
        case 1: self = .exitStudy
        default: self = .showMember
        }
    }
}

final class ChatSidebarView: UIView {
    let tableView = UITableView().then {
        $0.register(
            ChatSidebarTableViewCell.self,
            forCellReuseIdentifier: ChatSidebarTableViewCell.identifier
        )
        $0.rowHeight = ChatSidebarTableViewCell.cellHeight
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.separatorStyle = .none
        $0.allowsSelection = true
        $0.backgroundColor = .mogakcoColor.primarySecondary
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutView()
        layoutTableView()
    }
    
    private func layoutView() {
        self.backgroundColor = .mogakcoColor.primarySecondary
        self.clipsToBounds = true
    }
    
    private func layoutTableView() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
