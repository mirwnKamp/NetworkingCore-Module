//
//  RequestBuilder.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation
import NetworkingCoreInterfaces

public protocol RequestBuilding {
    func build(from endpoint: any Endpoint, config: NetworkConfiguration) throws -> URLRequest
}

final class RequestBuilder: RequestBuilding {
    func build(from endpoint: any Endpoint, config: NetworkConfiguration) throws -> URLRequest {
        guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidBaseURL
        }

        // baseURL may already have a path; append endpoint path safely
        components.path = (components.path as NSString).appendingPathComponent(endpoint.path)
        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else { throw NetworkError.invalidRequest }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = config.timeout

        // headers (config first, endpoint overrides)
        let merged = config.defaultHeaders.merging(endpoint.headers ?? [:]) { _, new in new }
        merged.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // body
        switch endpoint.body {
        case .json(let data):
            request.httpBody = data
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        case .data(let data):
            request.httpBody = data
        case .none:
            break
        }

        return request
    }
}
