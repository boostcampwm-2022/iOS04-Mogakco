//
//  AlertModalViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/12/07.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

struct Alert {
    let title: String
    let message: String
    let observer: AnyObserver<Bool>?
}

final class AlertModalViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.mediumBold
    }
    
    private let messageLabel = UILabel().then {
        $0.font = UIFont.mogakcoFont.smallBold
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.backgroundColor = UIColor.mogakcoColor.primarySecondary
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.layer.cornerRadius = 10.0
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = UIColor.mogakcoColor.primaryDefault
        $0.setTitleColor(UIColor.mogakcoColor.typographyPrimary, for: .normal)
        $0.layer.cornerRadius = 10.0
    }
    
    private let disposeBag = DisposeBag()
    
    init(alert: Alert) {
        super.init(nibName: nil, bundle: nil)
        bind(observer: alert.observer)
        configure(title: alert.title, message: alert.message)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(observer: AnyObserver<Bool>?) {
        Observable.merge([
            confirmButton.rx.tap.map { _ in true },
            cancelButton.rx.tap.map { _ in false }
        ])
        .subscribe(onNext: { [weak self] in
            observer?.onNext($0)
            self?.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    private func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    private func layout() {
        layoutTitleLabel()
        layoutMessageLabel()
        layoutButtonStackView()
    }
    
    private func attribute() {
        view.backgroundColor = .mogakcoColor.backgroundDefault
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func layoutMessageLabel() {
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
    
    private func layoutButtonStackView() {
        let stackView = createButtonStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func createButtonStackView() -> UIStackView {
        let arrangeSubviews = [cancelButton, confirmButton]
        arrangeSubviews.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(Layout.buttonHeight)
            }
        }
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.distribution = .fillEqually
        }
    }
}

extension Reactive where Base: UIViewController {
    var presentAlert: Binder<Alert> {
        return Binder(base) { base, alert in
            let viewController = AlertModalViewController(alert: alert)
            viewController.modalPresentationStyle = .pageSheet
            guard let sheet = viewController.sheetPresentationController else { return }
            sheet.detents = [
                .custom(resolver: { _ in
                    return 180
                })
            ]
            sheet.prefersGrabberVisible = true
            base.present(viewController, animated: true, completion: nil)
        }
    }
}
