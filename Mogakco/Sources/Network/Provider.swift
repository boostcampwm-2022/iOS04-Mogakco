//
//  Provider.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

struct EmptyResponse: Decodable {}
struct EmptyParameter: Encodable {}

class Provider: ProviderProtocol {
    private let session: Session

    init(session: Session) {
        self.session = session
    }
    
    static let `default`: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let networkEventLogger = NetworkEventLogger()
        let session = Session(configuration: configuration, eventMonitors: [networkEventLogger])
        return Provider(session: session)
    }()
    
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    print(T.self)
                    print(response.result)
                    switch response.result {
                    case let .success(data):
                        emitter.onNext(data)
                    case let .failure(error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
