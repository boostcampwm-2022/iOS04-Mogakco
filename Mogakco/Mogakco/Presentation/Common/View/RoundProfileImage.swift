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

    init(_ size: Int) {
        super.init(frame: .zero)
        layout(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(_ image: UIImage) {
        self.image = image
    }
    
    private func layout(_ size: Int) {
        contentMode = .scaleAspectFill
        image = UIImage(systemName: "person")
        
        snp.makeConstraints {
            $0.width.height.equalTo(size)
        }
        
        layer.cornerRadius = CGFloat(size/2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.mogakcoColor.backgroundSecondary?.cgColor
        clipsToBounds = true
    }
}
