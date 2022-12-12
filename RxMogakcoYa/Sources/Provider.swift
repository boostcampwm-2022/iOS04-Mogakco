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

public struct EmptyResponse: Decodable {}
public struct EmptyParameter: Encodable {}

public class Provider: ProviderProtocol {
    private let session: Session

    public init(session: Session) {
        self.session = session
    }
    
    public static let `default`: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let networkEventLogger = NetworkEventLogger()
        let session = Session(configuration: configuration, eventMonitors: [networkEventLogger])
        return Provider(session: session)
    }()
    
    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@")
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
    
    public func request(_ urlConvertible: URLRequestConvertible) -> Observable<Void> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .response() { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@")
                    switch response.result {
                    case .success:
                        emitter.onNext(())
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
