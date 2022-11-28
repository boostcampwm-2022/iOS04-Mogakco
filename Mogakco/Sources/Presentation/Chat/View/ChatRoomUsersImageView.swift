//
//  ChatRoomUsersImageView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class ChatRoomUsersImageView: UIView {
    
    enum Constant {
        static let imageInset = 1.0
        static let maxImageCount = 4
    }
    
    private lazy var imageLength: Double = {
        return self.frame.height / 2.0 - Constant.imageInset
    }()
    
    private lazy var roundImageViews: [RoundProfileImageView] = (0..<Constant.maxImageCount).map { _ in
        RoundProfileImageView.init(self.imageLength)
    }
    
    private lazy var topHorizontalStackView = UIStackView(arrangedSubviews: [
        self.roundImageViews[0],
        self.roundImageViews[1]
    ]).then {
        $0.axis = .horizontal
        $0.spacing = Constant.imageInset
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var bottomHorizontalStackView = UIStackView(arrangedSubviews: [
        self.roundImageViews[2],
        self.roundImageViews[3]
    ]).then {
        $0.axis = .horizontal
        $0.spacing = Constant.imageInset
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageURLs: [URL]) {
        zip(imageURLs.shuffled(), roundImageViews).forEach { imageURL, roundImageView in
            roundImageView.load(url: imageURL)
        }
        roundImageViews.enumerated().forEach { index, roundImageView in
            roundImageView.isHidden = imageURLs.count < index + 1
        }
        topHorizontalStackView.isHidden = imageURLs.isEmpty
        bottomHorizontalStackView.isHidden = imageURLs.count < 3
    }
    
    private func layout() {
        layoutEntireVerticalStackView()
    }
    
    private func attribute() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
    
    private func layoutEntireVerticalStackView() {
        let stackView = createEntireVerticalStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createEntireVerticalStackView() -> UIStackView {
        let arrangedSubviews = [bottomHorizontalStackView, topHorizontalStackView]
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .vertical
            $0.spacing = Constant.imageInset
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    }
}