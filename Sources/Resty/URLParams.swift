//
//  URLParam.swift
//  Resty
//
//  Created by Justin Reusch on 3/31/20.
//

import Foundation

/**
 Holds the key and value strings to use in an HTTP request/response header
 */
public struct URLParam: Hashable, Equatable {
    
    // ℹ️ Properties ------------------------------------------ /
    
    public var key: String
    public var value: String
    
    // 🏁 Initializers ------------------------------------------ /
    
    /// Default initializer
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    /// Init with a case of the RequestHeader enum
    public init(with header: RequestHeader) {
        self.init(key: header.key, value: header.value)
    }
}
