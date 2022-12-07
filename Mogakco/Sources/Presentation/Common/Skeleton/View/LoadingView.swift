//
//  LoadingView.swift
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

final class LoadingView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        loadinAnimation()
    }
}
