//
//  RoundProfileImage.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class RoundProfileImageView: UIImageView {

    init(_ length: Double) {
        super.init(frame: .zero)
        layout(length)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(_ image: UIImage) {
        self.image = image
    }
    
    private func layout(_ length: Double) {
        contentMode = .scaleAspectFill
        image = Image.profileDefault
        
        snp.makeConstraints {
            $0.width.height.equalTo(length)
        }
        
        layer.cornerRadius = length / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.mogakcoColor.backgroundSecondary?.cgColor
        clipsToBounds = true
    }
}
