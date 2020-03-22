//
//  HTTPHeaders.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/**
 Holds a grouping of HTTP headers, each with a key/value pairing
 */
public struct HTTPHeaders: KeyValueMap {
    
    // ℹ️ Properties ------------------------------------------ /
    
    public var values: [String : HTTPHeader] = [:]
    
    // 💻 Computed Properties --------------------------------- /
    
    public var headerList: [HTTPHeader] { Array(self.values.values) }
    
    public var headerSet: Set<HTTPHeader> { Set(self.values.values) }
    
    // 🏁 Initializers ------------------------------------------ /
    
    public init(with values: [String : String] = [:]) {
        _ = values.map { self.setValue($0.value, for: $0.key) }
    }
    
    public init(with headers: [RequestHeader]) {
        _ = headers.map { self.set($0.header, forKey: $0.key) }
    }
    
    public init(with headers: RequestHeader...) {
        self.init(with: headers)
    }
    
    public init(with headers: Set<HTTPHeader>) {
         _ = headers.map { self.set($0, forKey: $0.key) }
    }
    
    public init(with headers: [HTTPHeader]) {
        _ = headers.map { self.set($0, forKey: $0.key) }
    }
    
    public init(with headers: HTTPHeader...) {
         self.init(with: headers)
    }
    
    // 🏃‍♂️ Methods ------------------------------------------ /
    
    public mutating func setValue(_ value: String, for key: String) {
        if var header = values[key] {
            header.value = value
        } else {
            values[key] = HTTPHeader(key: key, value: value)
        }
    }
}
