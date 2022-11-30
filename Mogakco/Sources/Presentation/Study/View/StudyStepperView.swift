//
//  StudyStepperView.swift
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

final class StudyStepperView: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - UI
    
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textAlignment = .left
    }
    
    let countLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 16)
        $0.textAlignment = .left
        $0.text = "0"
    }
    
    let stepper = UIStepper().then {
        $0.stepValue = 1
        $0.minimumValue = 2
        $0.maximumValue = 8
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let subviews = [titleLabel, UIView(), countLabel, stepper]
        let stackView = UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.alignment = .center
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().inset(4)
        }
    }
    
    private func bind() {
        stepper.rx.value
            .map { "\(Int($0))" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
