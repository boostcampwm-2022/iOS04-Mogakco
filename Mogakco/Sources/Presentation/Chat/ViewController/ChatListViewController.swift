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
        static let headerViewHeight = Layout.tapbarHeaderViewHeight
    }
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle(Constant.headerViewTitle)
    }
    
    private let chatRoomTableView = UITableView().then {
        $0.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        $0.rowHeight = ChatRoomTableViewCell.Constant.cellHeight
        $0.backgroundColor = UIColor.mogakcoColor.backgroundDefault
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private let viewModel: ChatListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            viewWillAppear: rx.viewWillAppear.map { _ in }.asObservable(),
            selectedChatRoom: chatRoomTableView.rx.modelSelected(ChatRoom.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            deletedChatRoom: chatRoomTableView.rx.modelDeleted(ChatRoom.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        let output = viewModel.transform(input: input)

        output.chatRooms
            .drive(chatRoomTableView.rx.items) { tableView, index, chatRoom in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatRoomTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatRoomTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.configure(chatRoom: chatRoom)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.alert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    func layout() {
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
