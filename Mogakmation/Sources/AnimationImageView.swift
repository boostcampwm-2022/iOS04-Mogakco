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
    let iconImage = UIImageView()
    
    let rotateDuration: Int
    
    init(frame: CGRect, image: UIImage?, rotateDuration: Int) {
        self.rotateDuration = rotateDuration
        super.init(frame: frame)
        configImage(image: image)
        addRotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configImage(image: UIImage?) {
        iconImage.image = image
        addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addRotation() {
        let randomRotaionDirection = Double(
            [-1, 1].randomElement() ?? 1
        )
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi / 180 * 360 * randomRotaionDirection
        rotation.duration = CFTimeInterval(rotateDuration)
        rotation.repeatCount = Float.infinity
        iconImage.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func removeRotation() {
        iconImage.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
