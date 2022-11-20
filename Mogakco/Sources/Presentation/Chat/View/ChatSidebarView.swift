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

protocol ChatSidebarViewDelegate: AnyObject {
    func sidebarDidTap(row: ChatSidebarMenu)
}

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
    
    let tableView = UITableView()
    
    var delegate: ChatSidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configureTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
    }
    
    private func layout() {
        layoutView()
        layoutTableView()
    }
    
    private func layoutView() {
        self.backgroundColor = .white
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

// MARK: - UITableViewDataSource

extension ChatSidebarView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatSidebarMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = ChatSidebarMenu.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .mogakcoColor.typographyPrimary
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatSidebarView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sidebarDidTap(row: ChatSidebarMenu(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
