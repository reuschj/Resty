//
//  HTTPHeaderItem.swift
//  Resty
//
//  Created by Justin Reusch on 3/14/20.
//

import Foundation

/**
 Holds the key and value strings to use in an HTTP request/response header
 */
public struct HTTPHeaderItem: Hashable, Equatable {
    
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

// Extension adds conformance to `KeyValueConvertible` protocol
// (These are a bit unnecessary for `HTTPHeader`, but the protocol needs them in case a conforming type has an optional key or value)
extension HTTPHeaderItem: KeyValueConvertible {
    
    /// Looks up key
    func getKey() -> String { self.key }
    
    /// Sets  key
    mutating func setKey(_ key: String) {
        self.key = key
    }
    
    /// Looks up value
    func getValue() -> String? { self.value }
    func getValue(default defaultValue: String) -> String { value }
    
    /// Sets  value
    mutating func setValue(_ value: String) {
        self.value = value
    }
}
