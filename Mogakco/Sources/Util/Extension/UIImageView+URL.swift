//
//  UIImageView+URL.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

extension UIImageView {
    
    func load(url: URL, disposeBag: DisposeBag) {
        DefaultImageCacheService.shared.setImage(url) // setImage를 통해 각 메모리를 체크
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.image = UIImage(data: image)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAndEvent(url: URL) -> Observable<Bool> {
        return Observable.create { emitter in
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            emitter.onNext(false)
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}
