//
//  NetworkProtocol.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Alamofire
import RxSwift

public protocol ProviderProtocol: AnyObject {
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T>
}
