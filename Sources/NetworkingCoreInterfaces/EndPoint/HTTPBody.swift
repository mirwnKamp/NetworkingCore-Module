//
//  HTTPBody.swift
//  NetworkingCore
//
//  Created by Myron Kampourakis on 23/1/26.
//

import Foundation

public enum HTTPBody: Sendable {
    case json(Data)
    case data(Data)
}
