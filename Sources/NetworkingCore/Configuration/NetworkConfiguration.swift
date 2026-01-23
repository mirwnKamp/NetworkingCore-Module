//
//  NetworkConfiguration.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public struct NetworkConfiguration {
    public let baseURL: String
    public let defaultHeaders: [String: String]
    public let defaultQueryItems: [URLQueryItem]
    public let timeout: TimeInterval

    public init(
        baseURL: String,
        defaultHeaders: [String: String] = [:],
        defaultQueryItems: [URLQueryItem] = [],
        timeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.defaultQueryItems = defaultQueryItems
        self.timeout = timeout
    }
}
