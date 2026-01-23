//
//  NetworkConfiguration.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public struct NetworkConfiguration: Sendable {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let timeout: TimeInterval
    public let jsonDecoder: JSONDecoder
    public let jsonEncoder: JSONEncoder

    public init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        timeout: TimeInterval = 60,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
}
