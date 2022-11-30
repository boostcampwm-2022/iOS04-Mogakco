//
//  AnimationView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit

final class AnimationView: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addImages()
    }
    
    private func addImages() {
        (0..<5).forEach { _ in
            let imageView = AnimaionImageView(frame: randomPosition())
            addSubview(imageView)
            moveView(targetView: imageView)
        }
    }
    
    private func randomPosition() -> CGRect {
        let xPosition = Int.random(in: (Int(frame.minX - 50)..<Int(frame.maxX - 50)))
        let yPosition = Int.random(in: (Int(frame.minY - 50)..<Int(frame.maxY - 50)))
        
        return CGRect(x: xPosition, y: yPosition, width: 100, height: 100)
    }
    
    private func moveView(targetView: UIView) {
        let container = self.frame
        var currentCenter = CGPoint()
        var nextPoint: CGPoint = randomPoint()
        
        Timer.scheduledTimer(withTimeInterval: 0.017, repeats: true) { [weak self] _ in
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
    }
    
    private func randomPoint() -> CGPoint {
        while true {
            guard let xPosition = [-2, -2, -2, -2, 0, 2, 2, 2, 2].randomElement(),
                  let yPosition = [-2, -2, -2, -2, 0, 2, 2, 2, 2].randomElement(),
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
            nextXPoint = CGFloat(2)
        } else if current.x > container.maxX {
            nextXPoint = CGFloat(-2)
        } else { nextXPoint = nextPoint.x }
        
        if current.y < container.minY {
            nextYPoint = CGFloat(2)
        } else if current.y > container.maxY {
            nextYPoint = CGFloat(-2)
        } else { nextYPoint = nextPoint.y }
        
        return CGPoint(x: nextXPoint, y: nextYPoint)
    }
}
