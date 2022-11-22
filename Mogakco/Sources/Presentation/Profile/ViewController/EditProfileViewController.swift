//
//  EditProfileViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard

final class EditProfileViewController: ViewController {
    
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
    
    private let introuceCountTextView = CountTextView().then {
        $0.title = "소개"
        $0.maxCount = 100
        $0.placeholder = "자신을 소개해주세요."
    }
    
    private let completeButton = ValidationButton().then {
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
        $0.setTitle("완료", for: .normal)
    }
    
    private var viewModel: EditProfiileViewModel
    private let imagePicker = UIImagePickerController()
    private let selectedProfileImage = PublishRelay<UIImage>()
    
    init(viewModel: EditProfiileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureImagePicker()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind() {
        let input = EditProfiileViewModel.Input(
            name: nameCountTextField.rx.text.orEmpty.asObservable(),
            introduce: introuceCountTextView.rx.text.orEmpty.asObservable(),
            selectedProfileImage: selectedProfileImage.asObservable(),
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        addImageButton.rx.tap
            .subscribe(onNext: {
                self.presentImagePicker()
            })
            .disposed(by: disposeBag)
        
        output.originName
            .asDriver(onErrorJustReturn: "")
            .drive(nameCountTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.originIntroduce
            .asDriver(onErrorJustReturn: "")
            .drive(introuceCountTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.originProfileImage
            .asDriver(onErrorJustReturn: .init())
            .drive(roundProfileImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.inputValidation
            .asDriver(onErrorJustReturn: false)
            .drive(completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
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
        }
    }
    
    private func layoutIntrouceCountTextField() {
        contentView.addSubview(introuceCountTextView)
        introuceCountTextView.snp.makeConstraints {
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
            $0.top.equalTo(introuceCountTextView.snp.bottom)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }
}

// MARK: Picker

private extension EditProfileViewController {
    func configureImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func presentImagePicker() {
        present(imagePicker, animated: true)
    }
}

// MARK: Picker Delegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        var newImage: UIImage?
        
        if let possibleImage = info[.editedImage] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        if let image = newImage {
            selectedProfileImage.accept(image)
        }
        
        picker.dismiss(animated: true)
    }
}
