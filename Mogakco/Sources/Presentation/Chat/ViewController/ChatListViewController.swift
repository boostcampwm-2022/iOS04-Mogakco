//
//  ChatListViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatListViewController: UIViewController {
    
    enum Constant {
        static let headerViewTitle = "채팅 목록"
        static let headerViewHeight = 68.0
    }
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle(Constant.headerViewTitle)
    }
    
    private let chatRoomTableView = UITableView().then {
        $0.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        $0.rowHeight = ChatRoomTableViewCell.cellHeight
        $0.backgroundColor = UIColor.mogakcoColor.backgroundDefault
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel: ChatListViewModel
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mogakcoColor.backgroundDefault
        bind()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func bind() {
        let input = ChatListViewModel.Input(
            selectedChatRoom: chatRoomTableView.rx.itemSelected.map { _ in }.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.chatRoomList
            .asDriver(onErrorJustReturn: [])
            .drive(chatRoomTableView.rx.items) { tableView, index, chatRoom in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatRoomTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatRoomTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(chatRoom: chatRoom)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        layoutHeaderView()
        layoutChatRoomTableView()
    }
    
    private func layoutHeaderView() {
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constant.headerViewHeight)
        }
    }
    
    private func layoutChatRoomTableView() {
        view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
