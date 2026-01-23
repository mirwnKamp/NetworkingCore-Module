//
//  NetworkError.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 8/1/26.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case invalidBaseURL
    case invalidRequest
    case transport(Error)
    case invalidResponse
    case httpStatus(code: Int, data: Data?)
    case decoding(Error)
    case cancelled
    case timeout
}
