//
//  HTTPHeader.swift
//  Resty
//
//  Created by Justin Reusch on 3/14/20.
//

import Foundation

/**
 Holds the key and value strings of an HTTP header
 */
public struct HTTPHeader: Hashable, Equatable {
    var key: String
    var value: String
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    init(with header: RequestHeader) {
        self.init(key: header.key, value: header.value)
    }
}

extension HTTPHeader: KeyValueConvertible {
    func getKey() -> String { self.key }
    func getValue() -> String? { self.value }
    func getValue(default defaultValue: String) -> String { value }
    mutating func setKey(_ key: String) {
        self.key = key
    }
    mutating func setValue(_ value: String) {
        self.value = value
    }
}
