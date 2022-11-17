//
//  HalfModalViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/15.
//

import UIKit

import RxSwift
import Then

final class HalfModalViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.largeBold
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.mogakcoFont.mediumRegular
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.backgroundColor = UIColor.mogakcoColor.primarySecondary
        $0.setTitleColor(
            UIColor.mogakcoColor.typopraphyDisabled,
            for: .normal
        )
        $0.layer.cornerRadius = 8
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = UIColor.mogakcoColor.primaryDefault
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    required init(_ title: String, _ subTitle: String) {
        super.init(nibName: nil, bundle: nil)
        layout(title, subTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func layout(_ title: String, _ subTitle: String) {
        view.backgroundColor = .white
        layoutTitleLabel(title)
        layoutSubTitleLabel(subTitle)
        layoutCancelButton()
        layoutConfirmButton()
    }
    
    private func layoutTitleLabel(_ title: String) {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.text = title
    }
    
    private func layoutSubTitleLabel(_ subTitle: String) {
        view.addSubview(subTitleLabel)
        
        subTitleLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        subTitleLabel.text = subTitle
    }
    
    private func layoutCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(view.snp.centerX).inset(8)
        }
    }
    
    private func layoutConfirmButton() {
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(view.snp.centerX).offset(8)
        }
    }
}
