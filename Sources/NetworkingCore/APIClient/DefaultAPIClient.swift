//
//  DefaultAPIClient.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation
import NetworkingCoreInterfaces

public final class DefaultAPIClient: APIClient {
    private let config: NetworkConfiguration
    private let session: NetworkSession
    private let builder: RequestBuilding
    private let interceptors: [RequestInterceptor]
    private let retryStrategy: RetryStrategy?

    init(
        config: NetworkConfiguration,
        session: NetworkSession = URLSession.shared,
        interceptors: [RequestInterceptor] = [],
        retryStrategy: RetryStrategy? = nil,
        builder: RequestBuilding? = nil
    ) {
        self.config = config
        self.session = session
        self.interceptors = interceptors
        self.retryStrategy = retryStrategy
        self.builder = builder ?? RequestBuilder()
    }

    public func request(_ endpoint: any Endpoint) async throws {
        _ = try await perform(endpoint, decode: EmptyResponse.self)
    }

    public func request<T: Decodable>(_ endpoint: any Endpoint, as type: T.Type) async throws -> T {
        try await perform(endpoint, decode: T.self)
    }

    private func perform<T: Decodable>(_ endpoint: any Endpoint, decode: T.Type) async throws -> T {
        var attempt = 0

        while true {
            do {
                var request = try builder.build(from: endpoint, config: config)
                for i in interceptors {
                    request = try await i.adapt(request)
                }

                let (data, response) = try await session.data(for: request)

                guard let http = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard (200..<300).contains(http.statusCode) else {
                    throw NetworkError.httpStatus(code: http.statusCode, data: data)
                }

                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }

                do {
                    return try config.jsonDecoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decoding(error)
                }

            } catch {
                // map common URLSession errors
                let mapped = mapTransport(error)

                // retry?
                if let retryStrategy,
                   await retryStrategy.shouldRetry(
                        request: URLRequest(url: config.baseURL), // you can pass the real request by storing it
                        response: nil,
                        error: mapped,
                        attempt: attempt
                   ) {
                    attempt += 1
                    continue
                }

                throw mapped
            }
        }
    }

    private func mapTransport(_ error: Error) -> Error {
        let ns = error as NSError
        if ns.domain == NSURLErrorDomain {
            switch ns.code {
            case NSURLErrorCancelled: return NetworkError.cancelled
            case NSURLErrorTimedOut: return NetworkError.timeout
            default: return NetworkError.transport(error)
            }
        }
        if let e = error as? NetworkError { return e }
        return NetworkError.transport(error)
    }
}

private struct EmptyResponse: Decodable {
    init() {}
}
