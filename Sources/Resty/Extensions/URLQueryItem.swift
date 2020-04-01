//
//  URLQueryItem.swift
//  Resty
//
//  Created by Justin Reusch on 3/31/20.
//

import Foundation

/// Extends `URLQueryItem` to conform to `KeyValueConvertible` protocol
extension URLQueryItem: KeyValueConvertible {
    
    /// Looks up key
    func getKey() -> String { self.name }
    
    /// Sets  key
    mutating func setKey(_ key: String) {
        self.name = key
    }
    
    /// Looks up value
    func getValue() -> String? { self.value }
    func getValue(default defaultValue: String) -> String { value ?? defaultValue }
    
    /// Sets  value
    mutating func setValue(_ value: String) {
        self.value = value
    }
}
