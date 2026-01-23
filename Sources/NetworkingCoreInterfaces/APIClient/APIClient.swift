//
//  APIClient.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public protocol APIClient {
    func request(_ endpoint: any Endpoint) async throws // for empty responses (204 etc)
    func request<T: Decodable>(_ endpoint: any Endpoint, as type: T.Type) async throws -> T
}
