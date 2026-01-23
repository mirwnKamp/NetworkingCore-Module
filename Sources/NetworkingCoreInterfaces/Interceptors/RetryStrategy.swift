//
//  RetryStrategy.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 23/1/26.
//

import Foundation

public protocol RetryStrategy: Sendable {
    func shouldRetry(
        request: URLRequest,
        response: HTTPURLResponse?,
        error: Error,
        attempt: Int
    ) async -> Bool
}
