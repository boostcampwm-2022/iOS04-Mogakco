//
//  ViewModel.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/14.
//

import Foundation
import RxSwift

protocol InputOutput {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
