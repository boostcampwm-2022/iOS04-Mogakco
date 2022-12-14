//
//  AnimationView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit

public class AnimationView: UIView {
    
    public struct AnimationConfig {
        let isRandom: Bool
        let iconCount: Int
        let iconSize: CGFloat
        let moveInterval: Double
        let rotateDuration: Int
        let velociity: CGFloat
        var nagativeVelocity: CGFloat { velociity * -1 }
        var positiveVelocity: CGFloat { velociity }
        var directionProbability: [CGFloat] {
            [
                nagativeVelocity,
                nagativeVelocity,
                nagativeVelocity,
                nagativeVelocity,
                0,
                positiveVelocity,
                positiveVelocity,
                positiveVelocity,
                positiveVelocity
            ]
        }
        
        public init(
            isRandom: Bool = false,
            iconCount: Int = 5,
            iconSize: CGFloat = 80,
            moveInterval: Double = 0.017,
            rotateDuration: Int = 10,
            velociity: CGFloat = 1
        ) {
            self.isRandom = isRandom
            self.iconCount = iconCount
            self.iconSize = iconSize
            self.moveInterval = moveInterval
            self.rotateDuration = rotateDuration
            self.velociity = velociity
        }
    }
    
    private let animationConfig: AnimationConfig
    private var animationImages: [AnimationImageView] = []
    private var timers: [Timer] = []
    private var images: [UIImage] = []
    
    public init(images: [UIImage?], option: AnimationConfig = AnimationConfig()) {
        self.images = images.compactMap { $0 }
        self.animationConfig = option
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        addImages()
    }
    
    public func invalidate() {
        timers.forEach { $0.invalidate() }
        timers.removeAll()
        animationImages.forEach { $0.removeFromSuperview() }
        animationImages.removeAll()
    }
    
    private func addImages() {
        guard animationImages.isEmpty && timers.isEmpty else { return }
        
        (0..<animationConfig.iconCount).forEach { index in
            animationConfig.isRandom
            ? addImage(image: images.randomElement())
            : addImage(image: images[index % images.count])
        }
    }
    
    private func addImage(image: UIImage?) {
        let imageView = AnimationImageView(
            frame: randomPosition(),
            image: image,
            rotateDuration: animationConfig.rotateDuration
        )
        addSubview(imageView)
        animationImages.append(imageView)
        moveView(targetView: imageView)
    }
    
    private func randomPosition() -> CGRect {
        let iconHalfSize = animationConfig.iconSize / 2
        
        let xPosition = Int.random(in: (Int(frame.minX + iconHalfSize)..<Int(frame.maxX - iconHalfSize)))
        let yPosition = Int.random(in: (Int(frame.minY + iconHalfSize)..<Int(frame.maxY - iconHalfSize)))
        
        return CGRect(
            x: xPosition,
            y: yPosition,
            width: Int(animationConfig.iconSize),
            height: Int(animationConfig.iconSize)
        )
    }
    
    private func moveView(targetView: UIView) {
        let container = self.frame
        var currentCenter = CGPoint()
        var nextPoint: CGPoint = randomPoint()
        
        let moveTimer = Timer.scheduledTimer(
            withTimeInterval: animationConfig.moveInterval,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
            targetView.frame = CGRect(
                x: targetView.frame.minX + nextPoint.x,
                y: targetView.frame.minY + nextPoint.y,
                width: targetView.frame.width,
                height: targetView.frame.width
            )
            
            currentCenter = targetView.center
            nextPoint = self.selectDirection(
                container: container,
                current: currentCenter,
                nextPoint: nextPoint
            )
        }
        timers.append(moveTimer)
    }
    
    private func randomPoint() -> CGPoint {
        while true {
            guard let xPosition = animationConfig.directionProbability.randomElement(),
                  let yPosition = animationConfig.directionProbability.randomElement(),
                  !(xPosition == 0 && yPosition == 0)
            else { continue }
            
            return CGPoint(x: xPosition, y: yPosition)
        }
    }
    
    private func selectDirection(container: CGRect, current: CGPoint, nextPoint: CGPoint) -> CGPoint {
        if container.contains(current) { return nextPoint }
        let nextXPoint: CGFloat
        let nextYPoint: CGFloat
        
        if current.x < container.minX {
            nextXPoint = animationConfig.positiveVelocity
        } else if current.x > container.maxX {
            nextXPoint = animationConfig.nagativeVelocity
        } else { nextXPoint = nextPoint.x }
        
        if current.y < container.minY {
            nextYPoint = animationConfig.positiveVelocity
        } else if current.y > container.maxY {
            nextYPoint = animationConfig.nagativeVelocity
        } else { nextYPoint = nextPoint.y }
        
        return CGPoint(x: nextXPoint, y: nextYPoint)
    }
}
