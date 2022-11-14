//
//  StudyInfoView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import UIKit
import SnapKit
import Then

final class StudyInfoView: UIView {
    
    private lazy var imageView = UIImageView()
    private lazy var textLabel = UILabel().then {
        $0.textColor = .mogakcoColor.typographySecondary
        $0.font = .mogakcoFont.smallRegular
    }
    
    convenience init(image: UIImage?, text: String) {
        self.init(frame: .zero)
        imageView.image = image
        textLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubViews([imageView, textLabel])
        
        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView).offset(10)
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
    
    func setInfo(image: UIImage?, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}
