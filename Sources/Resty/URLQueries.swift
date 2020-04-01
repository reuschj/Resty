//
//  URLQueries.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/**
 Holds a grouping of URL queries, each with a key/value pairing
 */
public struct URLQueries: KeyValueMap {
    
    // ℹ️ Properties ------------------------------------------ /
    
    public var values: [String : URLQueryItem] = [:]
    
    // 💻 Computed Properties --------------------------------- /
    
    public var queryItems: [URLQueryItem] { Array(self.values.values) }
    
    // 🏁 Initializers ------------------------------------------ /
    
    /// Init with list of `URLQueryItem`s
    public init(with queryItems: [URLQueryItem] = []) {
        _ = queryItems.map { self.values[$0.name] = $0 }
    }
    
    /// Init with `Dictionary` of `String`s
    public init(with values: [String : String] = [:]) {
        _ = values.map { self.values[$0.key] = URLQueryItem(name: $0.key, value: $0.value) }
    }
}
