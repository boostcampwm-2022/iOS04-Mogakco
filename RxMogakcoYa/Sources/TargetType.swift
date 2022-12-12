//
//  TargetType.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding

public protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var header: HTTPHeaders { get }
    var path: String { get }
    var parameters: RequestParams? { get }
    var encoding: ParameterEncoding { get }
}

public extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        // var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        // appendingPathComponent 사용 시 path 내 ?를 %3f로 인식하여 임시 처리
        var urlRequest = try URLRequest(url: url.absoluteString + path, method: method)
        urlRequest.headers = header

        switch parameters {
        case let .query(request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            return try encoding.encode(urlRequest, with: params)
        case let .body(request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return try encoding.encode(urlRequest, with: params)
        case .none:
            return urlRequest
        }
    }
}

public enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
