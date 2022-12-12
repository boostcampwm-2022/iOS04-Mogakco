//
//  PolicyCheckBox.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

enum PolicyType: String {
    case total = ""
    case required = "필수"
    case option = "선택"
    case withdraw = "탈퇴"
}

final class PolicyCheckBox: UIView {
    
    let checkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        $0.tintColor = UIColor.mogakcoColor.typopraphyDisabled
    }
    
    private let bodyLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 16)
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let captionLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = UIColor.mogakcoColor.primaryDefault
    }
    
    private let detailButton = UIButton().then {
        $0.setTitle("자세히", for: .normal)
        $0.titleLabel?.font = UIFont.mogakcoFont.smallRegular
        $0.setTitleColor(UIColor.mogakcoColor.primaryDefault, for: .normal)
    }
    
    private let disposeBag = DisposeBag()
    
    private var link: String?
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setup(body: String, type: PolicyType, link: String? = nil) {
        self.bodyLabel.text = body
        self.link = link
        self.detailButton.isHidden = type == .total
        
        switch type {
        case .total, .required, .option:
            self.captionLabel.text = type.rawValue
        default:
            captionLabel.isHidden = true
            detailButton.isHidden = true
        }
    }
    
    private func layout() {
        let stackView = createTotalStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createTotalStackView() -> UIStackView {
        let subviews = [checkButton, bodyLabel, captionLabel, UIView(), detailButton]
        return UIStackView(arrangedSubviews: subviews).then {
            $0.axis = .horizontal
            $0.spacing = 10
        }
    }
    
    private func bind() {
        checkButton.rx.tap
            .withUnretained(self)
            .map { !$0.0.checkButton.isSelected }
            .bind(to: checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        detailButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: {
                guard let link = $0.0.link,
                      let url = URL(string: link),
                      UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UIButton {
    public var isSelected: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: [.touchUpInside],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }
}
