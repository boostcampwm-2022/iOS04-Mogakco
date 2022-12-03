//
//  ViewController.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/07.
//

import UIKit

import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let backButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(.mogakcoColor.primaryDefault, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mogakcoColor.backgroundDefault
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
