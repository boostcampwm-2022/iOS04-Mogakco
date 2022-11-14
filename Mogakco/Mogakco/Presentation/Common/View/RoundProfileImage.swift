//
//  RoundProfileImage.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class RoundProfileImage: UIView {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "person")
    }
    
    init(_ size: Int) {
        super.init(frame: .zero)
        layout(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(_ image: UIImage) {
        imageView.image = image
    }
    
    private func layout(_ size: Int) {
        layoutImageView(size)
    }
    
    private func layoutImageView(_ size: Int) {
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(size)
        }
        
        imageView.layer.cornerRadius = CGFloat(size/2)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.mogakcoColor.backgroundSecondary?.cgColor
        imageView.clipsToBounds = true
    }
    
}
