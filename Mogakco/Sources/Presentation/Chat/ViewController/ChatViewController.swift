//
//  ChatViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import Then

final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Constant {
        static let messageInputViewHeight = 100.0
        static let collectionViewSpacing = 12.0
        static let sidebarZPosition = 100.0
        static let collectionViewHeight = 60
    }
    
    private let backButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(.mogakcoColor.primaryDefault, for: .normal)
    }
    
    private lazy var messageInputView = MessageInputView().then {
        $0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 60)
        layout.minimumLineSpacing = Constant.collectionViewSpacing
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.tintColor = .white
        $0.collectionViewLayout = layout
        $0.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        $0.alwaysBounceVertical = true
    }
    
    private let studyInfoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        $0.tintColor = .mogakcoColor.primaryDefault
    }
    
    private lazy var sidebarView = ChatSidebarView().then {
        $0.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    private lazy var blackScreen = UIView(frame: self.view.bounds)
    
    private let disposeBag = DisposeBag()
    private let viewModel: ChatViewModel
    private let selectedUser = PublishSubject<User>()
    private let chatMenuSelected = PublishSubject<ChatMenu>()
    private var keyboardHeight = 0.0
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - ViewController Methods
    
    private func bind() {
        let input = ChatViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () }.asObservable(),
            viewWillDisappear: rx.viewWillDisappear.map { _ in () }.asObservable(),
            willEnterForeground: NotificationCenter.default
                .rx.notification(UIApplication.willEnterForegroundNotification).map { _ in () },
            didEnterBackground: NotificationCenter.default
                .rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in () },
            backButtonDidTap: backButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            studyInfoButtonDidTap: studyInfoButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            selectedSidebar: sidebarView.tableView.rx.modelSelected(ChatSidebarMenu.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            sendButtonDidTap: messageInputView.sendButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            inputViewText: messageInputView.messageInputTextView.rx.text.orEmpty.asObservable(),
            pagination: collectionView.refreshControl?.rx.controlEvent(.valueChanged)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            selectedUser: selectedUser
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            chatMenuSelected: chatMenuSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        bindChatCollection(output: output)
        bindSideBar(output: output)
        bindTextView()
        bindKeyboard()
    }

    private func layout() {
        configure()
        layoutCollectionView()
        layoutSideBar()
        layoutBlackScreen()
        layoutMessageInputView()
    }
    
    private func configure() {
        configureSideBar()
        configureBlackScreen()
        configureNavigationBar()
    }
    
    // MARK: - Binds
    
    func bindChatCollection(output: ChatViewModel.Output) {
        output.messages
            .drive(collectionView.rx.items) { [weak self] collectionView, index, chat in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChatCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? ChatCell else {
                    return UICollectionViewCell()
                }
                cell.layoutChat(chat: chat)
                
                cell.profileImageButton.rx.tap
                    .compactMap { chat.user }
                    .bind(to: self.selectedUser)
                    .disposed(by: self.disposeBag)
                
                cell.menuSelected
                    .bind(to: self.chatMenuSelected)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        output.sendMessageCompleted
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.messageInputView.messageInputTextView.text = nil
                self.collectionView.scrollToItem(
                    at: IndexPath(
                        row: self.collectionView.numberOfItems(inSection: 0) - 1,
                        section: 0),
                    at: .bottom,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        output.refreshFinished
            .emit(onNext: { [weak self] _ in
                self?.collectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        output.alert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    func bindSideBar(output: ChatViewModel.Output) {
        output.chatSidebarMenus
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
        
        output.showChatSidebarView
            .emit(onNext: { [weak self] _ in
                self?.showSidebarView()
            })
            .disposed(by: disposeBag)
        
        sidebarView.tableView.rx.itemSelected
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.hideSidebarView()
            })
            .disposed(by: disposeBag)
    }
    
    func bindTextView() {
        messageInputView.messageInputTextView.rx
            .didChange
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let size = CGSize(width: self.messageInputView.messageInputTextView.frame.width, height: .infinity)
                let estimatedSize = self.messageInputView.messageInputTextView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= Constant.messageInputViewHeight
                if isMaxHeight == self.messageInputView.messageInputTextView.isScrollEnabled { return }
                self.messageInputView.messageInputTextView.isScrollEnabled = isMaxHeight
                 self.messageInputView.messageInputTextView.reloadInputViews()
                print("DEBUG @@ : \(isMaxHeight)")
                self.setNeedsUpdateConstraints(isScrollEnabled: isMaxHeight)
            })
            .disposed(by: disposeBag)
    }
    
    func setNeedsUpdateConstraints(isScrollEnabled: Bool) {
        messageInputView.snp.remakeConstraints {
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(keyboardHeight)
            if isScrollEnabled {
                $0.top.lessThanOrEqualTo(self.view.snp.centerY)
            } else {
                $0.height.equalTo(Constant.messageInputViewHeight)
            }
        }
    }
    
    func bindKeyboard() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self else { return }
                self.updateMessageInputLayout(height: keyboardVisibleHeight)
                self.updateCollectionViewLayout(height: keyboardVisibleHeight)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configures
    
    private func configureSideBar() {
        sidebarView.layer.zPosition = Constant.sidebarZPosition
        // sidebarView.tableView.delegate = nil
        // sidebarView.tableView.dataSource = nil
        self.view.isUserInteractionEnabled = true
    }
    
    private func configureBlackScreen() {
        blackScreen.backgroundColor = .black.withAlphaComponent(0.5)
        blackScreen.isHidden = true
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "채팅"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: studyInfoButton)
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constant.messageInputViewHeight)
        }
    }
    
    private func layoutSideBar() {
        self.navigationController?.view.addSubview(sidebarView)
    }
    
    private func layoutBlackScreen() {
        view.addSubview(blackScreen)
        
        blackScreen.layer.zPosition = Constant.sidebarZPosition
    }
    
    private func layoutMessageInputView() {
        view.addSubview(messageInputView)
        
        messageInputView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).inset(Constant.messageInputViewHeight)
        }
    }
    
    private func updateMessageInputLayout(height: CGFloat) {
        if height == 0 {
            self.messageInputView.snp.remakeConstraints {
                $0.bottom.left.right.equalToSuperview()
                $0.top.equalTo(self.view.snp.bottom).inset(Constant.messageInputViewHeight)
            }
        } else {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                self.messageInputView.snp.remakeConstraints {
                    $0.left.right.equalTo(self.view.safeAreaLayoutGuide)
                    $0.bottom.equalToSuperview().inset(height)
                }
            }
        }
    }
    
    private func updateCollectionViewLayout(height: CGFloat) {
        if height == 0 {
            self.collectionView.snp.remakeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().inset(Constant.messageInputViewHeight)
            }
        } else {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                self.keyboardHeight = height
                self.collectionView.snp.remakeConstraints {
                    $0.top.left.right.equalToSuperview()
                    $0.bottom.equalTo(self.messageInputView.snp.top)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func showSidebarView() {
        navigationItem.leftBarButtonItem?.isHidden = true

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
        navigationItem.leftBarButtonItem?.isHidden = false
        
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
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        navigationItem.leftBarButtonItem?.isHidden = false
        
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

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 50
        )
        
        let estimatedCell = ChatCell(frame: frame)
        
        estimatedCell.layoutChat(chat: viewModel.messages.value[indexPath.item])
        estimatedCell.layoutIfNeeded()
        
        let height = estimatedCell.bubbleContainer.frame.height + estimatedCell.nameLabel.frame.height + 4.0
        
        return .init(width: view.frame.width, height: height)
    }
}
