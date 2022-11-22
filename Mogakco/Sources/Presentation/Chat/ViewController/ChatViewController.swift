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
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        $0.collectionViewLayout = layout
        $0.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        $0.showsHorizontalScrollIndicator = false
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
    
    var sidebarView: ChatSidebarView!
    var blackScreen: UIView!
    
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
        configure()
        layout()
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
    
    private func configure() {
        configureSideBar()
        configureBlackScreen()
        configureNavigationBar()
    }
    
    private func layout() {
        layoutCollectionView()
        layoutSideBar()
        layoutBlackScreen()
    }
    
    private func configureSideBar() {
        sidebarView = ChatSidebarView(frame: CGRect(
            x: view.frame.width,
            y: 0,
            width: 0,
            height: view.frame.height)
        )
        sidebarView.delegate = self
        sidebarView.layer.zPosition = 100
        self.view.isUserInteractionEnabled = true
    }
    
    private func layoutSideBar() {
        self.navigationController?.view.addSubview(sidebarView)
    }
    
    private func configureBlackScreen() {
        blackScreen = UIView(frame: self.view.bounds)
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
        
        let backButton = UIBarButtonItem(
            title: "이전",
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        backButton.tintColor = UIColor.mogakcoColor.primaryDefault
        
        let studyInfoButton = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(studyInfoDidTap)
        )
        [backButton, studyInfoButton].forEach {
            $0.tintColor = UIColor.mogakcoColor.primaryDefault
        }
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = studyInfoButton
    }
    
    private func layoutCollectionView() {
        collectionView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        collectionView.alwaysBounceVertical = true
    }
    
    func sidebarDidTap(row: ChatSidebarMenu) {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(
                x: self.view.frame.width,
                y: 0,
                width: 0,
                height: self.sidebarView.frame.height
            )
        }
        
        switch row {
        case .studyInfo:
            print("1")
        case .exitStudy:
            print("2")
        case .showMember:
            print("3")
        }
    }
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func studyInfoDidTap() {
        blackScreen.isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.sidebarView.frame = CGRect(
                    x: self.view.frame.width * (2 / 3),
                    y: 0,
                    width: 250,
                    height: self.sidebarView.frame.height)
            },
            completion: { _ in
                self.blackScreen.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: 300,
                    height: self.view.bounds.height)
            }
        )
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = true
        blackScreen.frame = view.bounds
        
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(
                x: self.view.frame.width,
                y: 0,
                width: 0,
                height: self.sidebarView.frame.height
            )
        }
    }
}

extension ChatViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 15
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChatCell.identifier,
            for: indexPath
        ) as? ChatCell else { return ChatCell() }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}
