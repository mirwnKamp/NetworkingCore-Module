//
//  AuthInterceptor.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation
import NetworkingCoreInterfaces

final class AuthInterceptor: RequestInterceptor {

    private let tokenProvider: TokenProvider

    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var req = request
        if let token = await tokenProvider.accessToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }
}
