//
//  HTTPMethod.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/**
 Enum of HTTP REST request method types
 */
enum HTTPMethod: String, RawRepresentable, CustomStringConvertible {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
    var description: String { self.rawValue }
}
