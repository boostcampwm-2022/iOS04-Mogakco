//
//  ViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/11/14.
//

import RxSwift
import UIKit

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    required init(coder: NSCoder) {
      fatalError("init(coder) has not been implemented")
    }
    
    func layout() {}
    func bind() {}
}
