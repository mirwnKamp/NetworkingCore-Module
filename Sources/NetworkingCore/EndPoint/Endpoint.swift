//
//  Untitled.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var timeout: TimeInterval? { get }
}

public extension Endpoint {
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
    var timeout: TimeInterval? { nil }
}
