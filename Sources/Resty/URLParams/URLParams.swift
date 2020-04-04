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
    
    public internal(set) var values: [String : URLParamItem] = [:]
    
    private var order: [String] = []
    
    // 💻 Computed Properties --------------------------------- /
    
    /// The string representation within the URL will be each of the param values joined by "/"
    public var description: String { paramStringList.joined(separator: "/") }
    
    /// An array of the param values
    public var paramStringList: [String] {
        Array(self.values.values).map { $0.description }
    }
    
    /// An array of `URLParam` instances
    public var paramList: [URLParamItem] { Array(self.values.values) }
    
    /// An set of `URLParam` instances
    public var paramSet: Set<URLParamItem> { Set(self.values.values) }
    
    // 🏁 Initializers ------------------------------------------ /
    
    public init(with values: [String : String] = [:]) {
        _ = values.map { self.setValue($0.value, forKey: $0.key) }
    }
    
    public init(with params: Set<URLParamItem>) {
        _ = params.map { self.set($0, forKey: $0.key) }
    }
    
    public init(with params: [URLParamItem] = []) {
        _ = params.map { self.set($0, forKey: $0.key) }
    }
    
    public init(with params: URLParamItem...) {
        self.init(with: params)
    }
    
    // 🏃‍♂️ Methods ------------------------------------------ /
    
    public mutating func setValue(_ value: String, forKey key: String) {
        if var param = values[key] {
            param.value = value
            if param.position == nil {
                param.position = order.count
                order.append(key)
            }
        } else {
            values[key] = URLParamItem(key: key, value: value)
            if var param = values[key] {
                param.position = order.count
                order.append(key)
            }
        }
    }
    
    public mutating func set(_ value: URLParamItem, forKey key: String) {
        if var param = values[key] {
            let position = param.position ?? order.count
            param = value
            param.position = position
            if position < order.count {
                order[position] = key
            } else {
                order.append(key)
            }
        } else {
            values[key] = value
            if var param = values[key] {
                param.position = order.count
                order.append(key)
            }
        }
    }
    
    public mutating func remove(key: String) -> String? {
        guard let position = values[key]?.position else { return nil }
        let removedValue = values.removeValue(forKey: key)?.value
        _ = order.remove(at: position)
        for index in position...(order.count - 1) {
            let keyToUpdate = order[index]
            values[keyToUpdate]?.position = index
        }
        return removedValue
    }
    
    public subscript(key: String) -> URLParamItem? {
        get { values[key] }
        set { newValue.map { set($0, forKey: key) } }
    }
        
   
    @discardableResult
    public func map<T>(_ transform: ((key: String, value: URLParamItem)) throws -> T) rethrows -> [T] {
        return try order.map { key in
            guard let value = values[key] else {
                throw URLParamsError.valueNotFound(key: key)
            }
            return try transform((key, value))
        }
    }
    
    @discardableResult
    public func mapValues<T>(_ transform: ((key: String, value: String?)) throws -> T) rethrows -> [T] {
        return try order.map { key in
            guard let value = values[key] else {
                throw URLParamsError.valueNotFound(key: key)
            }
            return try transform((key, value.value))
        }
    }
}

/**
 Errors for URLParams
 */
enum URLParamsError: Error, CustomStringConvertible {
    
    // 📰 Cases ------------------------------------------ /
    
    case valueNotFound(key: String)
    
    // 💻 Computed Properties --------------------------------- /
    
    var description: String {
        switch self {
        case .valueNotFound(key: let key):
            return "No value was found at key \"\(key)\"."
        }
    }
}
