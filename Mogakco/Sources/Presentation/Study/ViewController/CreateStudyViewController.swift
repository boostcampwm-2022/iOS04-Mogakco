//
//  CreateStudyViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/23.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CreateStudyViewController: ViewController {
    
    private let titleTextField = CountTextField().then {
        $0.title = "제목"
        $0.placeholder = "제목을 입력해주세요"
    }
    
    private let contentTextView = CountTextView().then {
        $0.title = "내용"
        $0.placeholder = "내용을 입력해주세요"
    }
    
    private let placeTextField = CountTextField().then {
        $0.title = "지역"
        $0.placeholder = "지역을 입력해주세요"
    }
    
    // MARK: 인원
    
    private let countStepper = StudyStepperView().then {
        $0.title = "인원"
    }
    
    // MARK: 날짜
    
    // MARK: 카테고리
    
    // MARK: 언어
    
    private let language = HashtagListView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(100.0)
        }
    }
    
    private let createButton = ValidationButton().then {
        $0.setTitle("스터디 생성하기", for: .normal)
        $0.snp.makeConstraints {
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
    
    private let viewModel: CreateStudyViewModel
    
    // MARK: - Inits
    
    init(viewModel: CreateStudyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "새로운 스터디"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "이전"
        navigationController?.navigationBar.tintColor = .mogakcoColor.primaryDefault
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func layout() {
        layoutTotalStackView()
        layoutCreateButton()
    }
    
    private func layoutTotalStackView() {
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        [titleTextField, contentTextView, placeTextField, countStepper, language].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func layoutCreateButton() {
        view.addSubview(createButton)
        createButton.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
