//
//  URLParams.swift
//  Resty
//
//  Created by Justin Reusch on 3/31/20.
//

import Foundation

/**
 Holds a grouping of HTTP headers, each with a key/value pairing
 */
public struct URLParams: KeyValueMap, CustomStringConvertible {
    
    // ℹ️ Properties ------------------------------------------ /
    
    public var values: [String : URLParam] = [:]
    
    // 💻 Computed Properties --------------------------------- /
    
    /// The string representation within the URL will be each of the param values joined by "/"
    public var description: String { paramStringList.joined(separator: "/") }
    
    /// An array of the param values
    public var paramStringList: [String] {
        Array(self.values.values).map { $0.description }
    }
    
    /// An array of `URLParam` instances
    public var paramList: [URLParam] { Array(self.values.values) }
    
    /// An set of `URLParam` instances
    public var paramSet: Set<URLParam> { Set(self.values.values) }
    
    // 🏁 Initializers ------------------------------------------ /
    
    public init(with values: [String : String] = [:]) {
        _ = values.map { self.setValue($0.value, for: $0.key) }
    }
    
    // 🏃‍♂️ Methods ------------------------------------------ /
    
    public mutating func setValue(_ value: String, for key: String) {
        if var param = values[key] {
            param.value = value
            if param.position == nil { param.position = count }
        } else {
            values[key] = URLParam(key: key, value: value)
            if var param = values[key] {
                param.position = count
            }
        }
    }
    
    public mutating func set(_ value: URLParam, forKey key: String) {
        if var param = values[key] {
            let position = param.position ?? count
            param = value
            param.position = position
        } else {
            values[key] = value
            if var param = values[key] {
                param.position = count
            }
        }
    }
    
    // TODO...
    public subscript(key: String) -> URLParam? {
        get { values[key] }
        set { values[key] = newValue }
    }
   
    
}
