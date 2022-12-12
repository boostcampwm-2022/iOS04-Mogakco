//
//  ParticipantCell.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ParticipantCell: UICollectionViewCell, Identifiable {
    
    static let size = CGSize(width: 110, height: 130)
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView = RoundProfileImageView(50)
    
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .mogakcoFont.mediumBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.text = "default User name"
    }
    
    private let userDescriptionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = MogakcoFontFamily.SFProDisplay.semibold.font(size: 14)
        $0.textColor = .mogakcoColor.typographySecondary
        $0.text = "default user desctiption"
    }
    
    private func layout() {
        layoutView()
        layoutImageView()
        layoutNameLabel()
        layoutDescriptionLabel()
    }
    
    private func layoutView() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.2
        clipsToBounds = false
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
    }
    
    private func layoutNameLabel() {
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(90)
            $0.top.equalTo(imageView.snp.bottom).offset(15)
        }
    }
    
    private func layoutDescriptionLabel() {
        addSubview(userDescriptionLabel)
        userDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(90)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    func setInfo(user: User?) {
        let isLoadImage = BehaviorSubject(value: true)
        
        isLoadImage
            .bind(to: imageView.rx.skeleton)
            .disposed(by: disposeBag)
        
        if let imageURLString = user?.profileImageURLString,
           let url = URL(string: imageURLString) {
            imageView.load(url: url)
            imageView.loadAndEvent(url: url)
                .bind(to: imageView.rx.skeleton)
                .disposed(by: disposeBag)
        } else {
            imageView.setPhoto(Image.profileDefault)
        }
        userNameLabel.text = user?.name ?? "None"
        userDescriptionLabel.text = user?.languages.first ?? "None"
    }
}
