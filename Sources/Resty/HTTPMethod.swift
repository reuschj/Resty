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
public enum HTTPMethod: String, RawRepresentable, CustomStringConvertible {
    
    // ✉️ Methods ------------------------------------------ /
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
    // 💻 Computed Properties --------------------------------- /
    
    public var description: String { self.rawValue }
}
