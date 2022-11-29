//
//  AutoLoginViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/29.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

final class AutoLoginViewController: ViewController {
    
    private let viewModel: AutoLoginViewModel
    
    init(viewModel: AutoLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = AutoLoginViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in }.asObservable()
        )
        _ = viewModel.transform(input: input)
    }
}
