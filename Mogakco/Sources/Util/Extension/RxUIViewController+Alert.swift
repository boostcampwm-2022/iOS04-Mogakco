//
//  RxUIViewController+Alert.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

extension Reactive where Base: UIViewController {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제가 발생했어요", message: message, preferredStyle: .alert)

            let action = UIAlertAction(title: "확인", style: .default, handler: nil)

            alertController.addAction(action)

            base.present(alertController, animated: true, completion: nil)
        }
    }
}
