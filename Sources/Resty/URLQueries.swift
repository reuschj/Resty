//
//  URLQueries.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

extension URLQueryItem: KeyValueStore {
    var key: String {
        get { self.name }
        set { self.name = newValue }
    }
    init(key: String, value: String) {
        self.init(name: key, value: value)
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
