//
//  ChatViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatViewController: ViewController {
    
    private lazy var messageInputView = MessageInputView().then {
        $0.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 0
        )
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 16,
            left: 0,
            bottom: 0,
            right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 60)
        layout.minimumLineSpacing = 8.0
        $0.collectionViewLayout = layout
        $0.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        $0.alwaysBounceVertical = true
    }
    
    let backButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(.mogakcoColor.primaryDefault, for: .normal)
    }
    
    let studyInfoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        $0.tintColor = .mogakcoColor.primaryDefault
    }
    
    lazy var sidebarView = ChatSidebarView().then {
        $0.frame = CGRect(
            x: view.frame.width,
            y: 0,
            width: view.frame.width,
            height: view.frame.height)
    }
    
    lazy var blackScreen = UIView(frame: self.view.bounds)
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func layout() {
        configure()
        layoutCollectionView()
        layoutSideBar()
        layoutBlackScreen()
    }
    
    private func configure() {
        configureSideBar()
        configureBlackScreen()
        configureNavigationBar()
    }
    
    override func bind() {
        let input = ChatViewModel.Input(
            backButtonDidTap: backButton.rx.tap.asObservable(),
            studyInfoButtonDidTap: studyInfoButton.rx.tap.asObservable(),
            selectedSidebar: sidebarView.tableView.rx.itemSelected.asObservable(),
            sendButtonDidTap: messageInputView.sendButton.rx.tap.asObservable(),
            inputViewText: messageInputView.messageInputTextView.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)
        
        Driver<[ChatSidebarMenu]>.just(ChatSidebarMenu.allCases)
            .drive(sidebarView.tableView.rx.items) { tableView, index, menu in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatSidebarTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatSidebarTableViewCell else {
                    return UITableViewCell()
                }

                cell.menuLabel.text = menu.rawValue

                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.messages
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { collectionView, index, chat in
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChatCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatCell else {
                    return UICollectionViewCell()
                }
                cell.layoutChat(chat: chat)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.showChatSidebarView
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.showSidebarView()
            }
            .disposed(by: disposeBag)
        
        output.selectedSidebar
            .subscribe { [weak self] row in
                guard let self = self else { return }
                self.hideSidebarView()
                self.sidebarMenuDidTap(row: row)
            }
            .disposed(by: disposeBag)
        
        output.sendMessage
            .withUnretained(self)
            .subscribe { _ in
                self.messageInputView.messageInputTextView.text = nil
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(
                    at: IndexPath(
                        row: self.collectionView.numberOfItems(inSection: 0) - 1,
                        section: 0),
                    at: .bottom,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func configureSideBar() {
        sidebarView.layer.zPosition = 100
        sidebarView.tableView.delegate = nil
        sidebarView.tableView.dataSource = nil
        self.view.isUserInteractionEnabled = true
    }
    
    private func layoutSideBar() {
        self.navigationController?.view.addSubview(sidebarView)
    }
    
    private func configureBlackScreen() {
        blackScreen.backgroundColor = .black.withAlphaComponent(0.5)
        blackScreen.isHidden = true
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
    private func layoutBlackScreen() {
        view.addSubview(blackScreen)
        
        blackScreen.layer.zPosition = 100
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "채팅"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: studyInfoButton)
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    private func showSidebarView() {
        blackScreen.isHidden = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.sidebarView.frame = CGRect(
                    x: self.view.frame.width * (2 / 3),
                    y: 0,
                    width: self.view.frame.width * (1 / 3),
                    height: self.sidebarView.frame.height)
                
                self.blackScreen.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.view.frame.width * (2 / 3),
                    height: self.view.bounds.height)
            }
        )
    }
    
    private func hideSidebarView() {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(
                x: self.view.frame.width,
                y: 0,
                width: self.sidebarView.frame.width,
                height: self.sidebarView.frame.height
            )
        }
    }
    
    private func sidebarMenuDidTap(row: ChatSidebarMenu) {
        switch row {
        case .studyInfo:
            print("1")
        case .exitStudy:
            print("2")
        case .showMember:
            print("3")
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = true
        blackScreen.frame = view.bounds
        
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(
                x: self.view.frame.width,
                y: 0,
                width: self.view.frame.width,
                height: self.sidebarView.frame.height
            )
        }
    }
}
