//
//  NetworkResponseValidator.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public enum NetworkResponseValidator {
    static func validate(data: Data, response: URLResponse) throws -> Data {
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.server(statusCode: http.statusCode, data: data)
        }
        return data
    }
}
