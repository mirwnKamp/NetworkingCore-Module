//
//  RequestInterceptor.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public protocol RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest

    func shouldRetry(
        request: URLRequest,
        response: URLResponse?,
        data: Data?,
        error: Error?
    ) async -> Bool
}

public extension RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest { request }

    func shouldRetry(
        request: URLRequest,
        response: URLResponse?,
        data: Data?,
        error: Error?
    ) async -> Bool { false }
}
