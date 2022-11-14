//
//  ViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/07.
//

import RxSwift
import UIKit

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
