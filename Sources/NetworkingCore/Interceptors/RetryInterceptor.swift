//
//  RetryInterceptor.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public final class RetryInterceptor: RequestInterceptor {

    private let maxRetries: Int
    private let retryStatusCodes: Set<Int>

    // κρατάμε μετρητή “ανά request” απλά με header (για demo)
    private let retryHeaderKey = "X-Retry-Count"

    public init(
        maxRetries: Int = 1,
        retryStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
    ) {
        self.maxRetries = maxRetries
        self.retryStatusCodes = retryStatusCodes
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        request
    }

    public func shouldRetry(
        request: URLRequest,
        response: URLResponse?,
        data: Data?,
        error: Error?
    ) async -> Bool {

        let currentCount = Int(request.value(forHTTPHeaderField: retryHeaderKey) ?? "0") ?? 0
        guard currentCount < maxRetries else { return false }

        if let http = response as? HTTPURLResponse {
            return retryStatusCodes.contains(http.statusCode)
        }

        // network errors => retry (π.χ. offline/timeout) αν θες
        return error != nil
    }

    /// helper για να αυξήσεις retry count (αν το θες πιο σωστά)
    public func incrementRetryCount(_ request: URLRequest) -> URLRequest {
        var req = request
        let current = Int(req.value(forHTTPHeaderField: retryHeaderKey) ?? "0") ?? 0
        req.setValue("\(current + 1)", forHTTPHeaderField: retryHeaderKey)
        return req
    }
}
