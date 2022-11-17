//
//  ViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/07.
//

import UIKit

import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mogakcoColor.backgroundDefault
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
