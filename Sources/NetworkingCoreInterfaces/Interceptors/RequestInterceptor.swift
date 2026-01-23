//
//  RequestInterceptor.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) async throws -> URLRequest
}

public extension RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest { request }
}
