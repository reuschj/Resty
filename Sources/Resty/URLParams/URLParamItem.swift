//
//  URLParamItem.swift
//  Resty
//
//  Created by Justin Reusch on 3/31/20.
//

import Foundation

/**
 Holds the key and value strings to use in a URL param
 */
public struct URLParamItem: Hashable, Equatable, CustomStringConvertible {
    
    // ℹ️ Properties ------------------------------------------ /
    
    public var key: String
    public var value: String
    var position: Int?
    
    // 💻 Computed Properties --------------------------------- /
    
    /// Ultimately, only the value will remain in the string representation within the URL
    public var description: String { value }
    
    // 🏁 Initializers ------------------------------------------ /
    
    /// Default initializer
    public init(key: String, value: String) {
        self.key = key
        self.value = value
        self.position = nil
    }
}

// Extension adds conformance to `KeyValueConvertible` protocol
// (These are a bit unnecessary for `URLParam`, but the protocol needs them in case a conforming type has an optional key or value)
extension URLParamItem: KeyValueConvertible {
    
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
