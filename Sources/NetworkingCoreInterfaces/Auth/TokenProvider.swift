//
//  TokenProvider.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 23/1/26.
//

import Foundation

public protocol TokenProvider: Sendable {
    func accessToken() async -> String?
}
