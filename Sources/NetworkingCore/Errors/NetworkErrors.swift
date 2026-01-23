//
//  NetworkErrors.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case server(statusCode: Int, data: Data?)
    case decoding(Error)
    case underlying(Error)

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.server(a, _), .server(b, _)):
            return a == b
        case (.decoding, .decoding),
             (.underlying, .underlying):
            return true
        default:
            return false
        }
    }
}
