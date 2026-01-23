//
//  APIClient.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public protocol APIClient {
    func request(_ endpoint: Endpoint) async throws -> Data
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
