//
//  AnimaionImageView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit

final class AnimaionImageView: UIView {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configRandomImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configRandomImage() {
        imageView.image = UIImage(named: Languages.randomImageID() )
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let randomRotaionDirection = Double([-2, 2].randomElement() ?? 2)
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * randomRotaionDirection
        rotation.duration = 10
        rotation.repeatCount = Float.infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
