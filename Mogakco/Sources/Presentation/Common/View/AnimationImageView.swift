//
//  AnimationImageView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit

final class AnimationImageView: UIView {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configRandomImage()
        addRotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configRandomImage() {
        imageView.image = UIImage(named: Language.randomImageID() )
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addRotation() {
        let randomRotaionDirection = Double(
            [-1, 1].randomElement() ?? 1
        )
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi / 180 * 360 * randomRotaionDirection
        rotation.duration = CFTimeInterval(AnimationView.Animation.rotateDuration)
        rotation.repeatCount = Float.infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func removeRotation() {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
