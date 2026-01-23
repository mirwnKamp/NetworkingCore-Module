//
//  DefaultAPIClient.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public final class DefaultAPIClient: APIClient {

    private let session: NetworkSession
    private let config: NetworkConfiguration
    private let decoder: JSONDecoder
    private let interceptor: RequestInterceptor?

    public init(
        config: NetworkConfiguration,
        session: NetworkSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        interceptor: RequestInterceptor? = nil
    ) {
        self.config = config
        self.session = session
        self.decoder = decoder
        self.interceptor = interceptor
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    public func request(_ endpoint: Endpoint) async throws -> Data {
        var request = try endpoint.makeRequest(using: config)

        if let interceptor {
            request = try await interceptor.adapt(request)
        }

        do {
            let (data, response) = try await session.data(for: request)
            let validated = try NetworkResponseValidator.validate(data: data, response: response)

            // Retry policy (αν έχει)
            if let retryInterceptor = interceptor as? RetryInterceptor,
               await retryInterceptor.shouldRetry(request: request, response: response, data: data, error: nil) {

                let retryRequest = retryInterceptor.incrementRetryCount(request)
                let (data2, response2) = try await session.data(for: retryRequest)
                return try NetworkResponseValidator.validate(data: data2, response: response2)
            }

            return validated
        } catch {
            if let interceptor,
               await interceptor.shouldRetry(request: request, response: nil, data: nil, error: error) {
                let (data2, response2) = try await session.data(for: request)
                return try NetworkResponseValidator.validate(data: data2, response: response2)
            }
            throw NetworkError.underlying(error)
        }
    }
}
