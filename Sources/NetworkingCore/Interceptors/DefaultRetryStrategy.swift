//
//  DefaultRetryStrategy.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 23/1/26.
//

import Foundation
import NetworkingCoreInterfaces

final class DefaultRetryStrategy: RetryStrategy {

    private let maxRetries: Int
    private let retryStatusCodes: Set<Int>

    init(
        maxRetries: Int = 2,
        retryStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
    ) {
        self.maxRetries = maxRetries
        self.retryStatusCodes = retryStatusCodes
    }

    func shouldRetry(
        request: URLRequest,
        response: HTTPURLResponse?,
        error: Error,
        attempt: Int
    ) async -> Bool {
        
        guard attempt < maxRetries else { return false }
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .timeout, .transport:
                return true
            default:
                return false
            }
        }
        
        if let status = response?.statusCode {
            return retryStatusCodes.contains(status)
        }
        
        return false
    }
}
