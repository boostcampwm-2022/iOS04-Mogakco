//
//  SkeletonView.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SkeletonView: UIView {
    
    enum ViewType {
        case image
        case rectList
        case chatList
        case none
    }
    
    let type: ViewType
    
    init(frame: CGRect, type: ViewType) {
        self.type = type
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        selectBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selectBaseView() {
        let subView: UIView
        
        switch type {
        case .image: subView = ImageSkeletonView()
        case .rectList: subView = RectListSkeletonView(frame: frame)
        case .chatList: subView = ListSkeletonView(frame: frame)
        case .none : subView = ImageSkeletonView()
        }
        
        addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
