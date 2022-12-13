//
//  RxUIImageView+URL.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

extension Reactive where Base: UIImageView {
    var loadImage: Binder<URL> {
        let disposeBag = DisposeBag()
        return Binder(base) { base, url in
            base.load(url: url, disposeBag: disposeBag)
        }
    }
}
