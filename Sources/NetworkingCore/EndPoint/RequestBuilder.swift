//
//  RequestBuilder.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public extension Endpoint {

    func makeRequest(using config: NetworkConfiguration) throws -> URLRequest {
        guard var components = URLComponents(string: config.baseURL) else {
            throw NetworkError.invalidURL
        }

        components.path = (components.path as NSString).appendingPathComponent(path)
        var mergedQueryItems = config.defaultQueryItems
        if let queryItems { mergedQueryItems.append(contentsOf: queryItems) }
        components.queryItems = mergedQueryItems.isEmpty ? nil : mergedQueryItems

        guard let url = components.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        // headers: default + endpoint overrides
        var finalHeaders = config.defaultHeaders
        headers?.forEach { finalHeaders[$0.key] = $0.value }
        finalHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        request.timeoutInterval = timeout ?? config.timeout
        return request
    }
}
