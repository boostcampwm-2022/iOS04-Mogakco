//
//  UIImageView+URL.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

extension UIImageView {
    func load(url: String, disposeBag: DisposeBag) {
        DefaultImageCacheService.shared.setImage(url)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.image = UIImage(data: image)
            })
            .disposed(by: disposeBag)
    }
}
