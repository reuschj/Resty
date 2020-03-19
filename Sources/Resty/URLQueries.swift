//
//  URLQueries.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

extension URLQueryItem: KeyValueConvertible {    
    func getKey() -> String { self.name }
    func getValue() -> String? { self.value }
    func getValue(default defaultValue: String) -> String { value ?? defaultValue }
    mutating func setKey(_ key: String) {
        self.name = key
    }
    mutating func setValue(_ value: String) {
        self.value = value
    }
}

public struct URLQueries: KeyValueMap {
    var values: [String : URLQueryItem] = [:]
    var queryItems: [URLQueryItem] { Array(self.values.values) }
    init(with queryItems: [URLQueryItem] = []) {
        _ = queryItems.map { self.values[$0.name] = $0 }
    }
    init(with values: [String : String] = [:]) {
        _ = values.map { self.values[$0.key] = URLQueryItem(name: $0.key, value: $0.value) }
    }
}
