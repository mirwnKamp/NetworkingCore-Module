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
    private var lastResponse: HTTPURLResponse?
    
    public init(
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
        _ = try await execute(endpoint)
    }

    public func request<T: Decodable>(
        _ endpoint: any Endpoint,
        as type: T.Type
    ) async throws -> T {

        let data = try await execute(endpoint)

        do {
            return try config.jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    private func execute(_ endpoint: any Endpoint) async throws -> Data {
        var attempt = 0

        while true {
            try Task.checkCancellation()

            var request = try builder.build(from: endpoint, config: config)
            for interceptor in interceptors {
                request = try await interceptor.adapt(request)
            }

            do {
                let (data, response) = try await session.data(for: request)

                guard let http = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard (200..<300).contains(http.statusCode) else {
                    throw NetworkError.httpStatus(
                        code: http.statusCode,
                        data: data
                    )
                }

                return data

            } catch {
                if Task.isCancelled {
                    throw NetworkError.cancelled
                }

                let mapped = mapTransport(error)

                if let retryStrategy,
                   await retryStrategy.shouldRetry(
                        request: request,
                        response: lastResponse,
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
        if let networkError = error as? NetworkError {
            return networkError
        }

        let ns = error as NSError
        guard ns.domain == NSURLErrorDomain else {
            return NetworkError.transport(error)
        }

        switch ns.code {
        case NSURLErrorCancelled:
            return NetworkError.cancelled

        case NSURLErrorTimedOut:
            return NetworkError.timeout

        case NSURLErrorNotConnectedToInternet,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorCannotConnectToHost,
             NSURLErrorCannotFindHost:
            return NetworkError.transport(error)

        default:
            return NetworkError.transport(error)
        }
    }
}
