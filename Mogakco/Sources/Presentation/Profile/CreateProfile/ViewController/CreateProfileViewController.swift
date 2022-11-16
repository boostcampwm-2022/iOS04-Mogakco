//
//  CreateProfileViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class CreateProfileViewController: ViewController {
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
    private let roundProfileImageView = RoundProfileImageView(120.0).then {
        $0.snp.makeConstraints {
            $0.size.equalTo(120.0)
        }
    }
    
    private let addImageButton = UIButton()
    
    private let nameCountTextField = CountTextField().then {
        $0.title = "이름"
        $0.maxCount = 10
        $0.placeholder = "이름을 입력해주세요."
    }
    
    private let introuceCountTextField = CountTextField().then {
        $0.title = "소개"
        $0.maxCount = 100
        $0.placeholder = "자신을 소개해주세요."
    }
    
    private let completeButton = ValidationButton().then {
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
        $0.setTitle("완료", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func configureUI() {
        configureNavigationBar()
    }

    override func layout() {
        layoutScrollView()
        layoutRoundProfileImageView()
        layoutAddImageButton()
        layoutNameCountTextField()
        layoutIntrouceCountTextField()
        layoutMarginView()
        layoutNextButton()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "프로필 생성"
        
    }
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func layoutRoundProfileImageView() {
        contentView.addSubview(roundProfileImageView)
        roundProfileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
        }
    }
    
    private func layoutAddImageButton() {
        contentView.addSubview(addImageButton)
        addImageButton.snp.makeConstraints {
            $0.edges.equalTo(roundProfileImageView)
        }
    }
    
    private func layoutNameCountTextField() {
        contentView.addSubview(nameCountTextField)
        nameCountTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(roundProfileImageView.snp.bottom).offset(16.0)
            $0.height.equalTo(120.0)
        }
    }
    
    private func layoutIntrouceCountTextField() {
        contentView.addSubview(introuceCountTextField)
        introuceCountTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(nameCountTextField.snp.bottom).offset(8.0)
            $0.height.equalTo(240.0)
        }
    }
    
    private func layoutMarginView() {
        let marginView = UIView()
        contentView.addSubview(marginView)
        marginView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(introuceCountTextField.snp.bottom)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(56.0)
        }
    }
    
}
