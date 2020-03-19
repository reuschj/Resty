//
//  KeyValueMap.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/**
 A type that can be used in a key:value situation.
 This only requires that they type can extract a key and possible value and not that they type have explicit "key" and "value" properties
 */
protocol KeyValueConvertible {
    associatedtype Key where Key: Hashable
    associatedtype Value where Value: Equatable & Comparable
    func getKey() -> Key
    func getValue() -> Value?
    func getValue(default: Value) -> Value
    mutating func setKey(_ key: Key) -> Void
    mutating func setValue(_ value: Value) -> Void
}

/**
 Holds a grouping of types with a key and value and uses the key of each for hash lookup
 */
protocol KeyValueMap {
    associatedtype KeyValuePair where KeyValuePair: KeyValueConvertible & Hashable
    
    var values: [KeyValuePair.Key : KeyValuePair] { get set }
    var count: Int { get }
    
    subscript(key: KeyValuePair.Key) -> KeyValuePair? { get set }
    
    func has(_ value: KeyValuePair) -> Bool
    func has(key: KeyValuePair.Key) -> Bool
    func has(value: KeyValuePair.Value) -> Bool
    
    func get(forKey key: KeyValuePair.Key) -> KeyValuePair?
    func getValue(forKey key: KeyValuePair.Key) -> KeyValuePair.Value?
    
    mutating func set(_ value: KeyValuePair, forKey key: KeyValuePair.Key) -> Void
    mutating func setValue(_ value: KeyValuePair.Value, forKey key: KeyValuePair.Key) -> Void
    
    mutating func remove(key: KeyValuePair.Key) -> KeyValuePair.Value?
    
    @discardableResult func map<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair)) throws -> T) rethrows -> [T]
    @discardableResult func mapValues<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair.Value?)) throws -> T) rethrows -> [T]
}

/**
 Default implementations
 */
extension KeyValueMap {
    var count: Int { values.count }
    
    subscript(key: KeyValuePair.Key) -> KeyValuePair? {
        get { values[key] }
        set { values[key] = newValue }
    }
    
    func has(_ value: KeyValuePair) -> Bool { values[value.getKey()] != nil }
    func has(key: KeyValuePair.Key) -> Bool { values[key] != nil }
    func has(value: KeyValuePair.Value) -> Bool {
        for keyValuePair in values {
            guard let embeddedValue = keyValuePair.value.getValue() else { continue }
            if embeddedValue == value { return true }
        }
        return false
    }
    
    func get(forKey key: KeyValuePair.Key) -> KeyValuePair? { values[key] }
    func getValue(forKey key: KeyValuePair.Key) -> KeyValuePair.Value? { values[key]?.getValue() }
    
    mutating func set(_ value: KeyValuePair, forKey key: KeyValuePair.Key) { values[key] = value }
    mutating func setValue(_ value: KeyValuePair.Value, forKey key: KeyValuePair.Key) {
        values[key]?.setValue(value)
    }
    
    mutating func remove(key: KeyValuePair.Key) -> KeyValuePair.Value? { values.removeValue(forKey: key)?.getValue() }
    
    @discardableResult
    func map<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair)) throws -> T) rethrows -> [T] {
        try values.map(transform)
    }
    
    @discardableResult
    func mapValues<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair.Value?)) throws -> T) rethrows -> [T] {
        try values.map { try transform((key: $0.key, value: $0.value.getValue())) }
    }
}
