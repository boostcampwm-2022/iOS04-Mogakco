//
//  ChatViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatViewController: UIViewController {
    
    private let chatRoomTableView = UITableView().then {
        $0.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        $0.rowHeight = ChatRoomTableViewCell.cellHeight
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        layout()
    }
    
    func bind() {
        Driver<[Int]>.just([1, 2, 3, 4])
            .drive(chatRoomTableView.rx.items) { tableView, index, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatRoomTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatRoomTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        layoutChatRoomTableView()
    }
    
    private func layoutChatRoomTableView() {
        view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
