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

final class ChatViewController: UICollectionViewController {
    
    private lazy var customInputView = CustomInputAccessoryView(frame: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: view.frame.width,
                                                                              height: 90))
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        configureNavigationBar()
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
        return customInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func layout() {
        layoutCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "채팅"
        
        let backButton = UIBarButtonItem(title: "이전",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonDidTap))
        backButton.tintColor = UIColor.mogakcoColor.primaryDefault
        
        let studyInfoButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(studyInfoDidTap))
        [backButton, studyInfoButton].forEach {
            $0.tintColor = UIColor.mogakcoColor.primaryDefault
        }
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = studyInfoButton
    }
    
    private func layoutCollectionView() {
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(90)
        }
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        collectionView.alwaysBounceVertical = true
    }
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func studyInfoDidTap() {
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier,
                                                            for: indexPath) as? ChatCell else { return ChatCell() }
        return cell
    }
}

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
