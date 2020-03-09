//
//  KeyValueMap.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

protocol KeyValueStore {
    associatedtype Key where Key: Hashable
    associatedtype Value where Value: Equatable & Comparable
    var key: Key { get set }
    var value: Value { get set }
    init(key: String, value: String)
}

protocol KeyValueMap {
    associatedtype KeyValuePair where KeyValuePair: KeyValueStore & Hashable
    
    var values: [KeyValuePair.Key:KeyValuePair] { get set }
    var count: Int { get }
    
    subscript(key: KeyValuePair.Key) -> KeyValuePair? { get set }
    
    func has(_ value: KeyValuePair) -> Bool
    func has(key: KeyValuePair.Key) -> Bool
    func has(value: KeyValuePair.Value) -> Bool
    
    func get(forKey key: KeyValuePair.Key) -> KeyValuePair?
    func getValue(forKey key: KeyValuePair.Key) -> KeyValuePair.Value?
    
    mutating func set(_ value: KeyValuePair, for key: KeyValuePair.Key) -> Void
    mutating func setValue(_ value: KeyValuePair.Value, for key: KeyValuePair.Key) -> Void
    
    mutating func remove(key: KeyValuePair.Key) -> KeyValuePair.Value?
    
    @discardableResult func map<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair)) throws -> T) rethrows -> [T]
    @discardableResult func mapValues<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair.Value)) throws -> T) rethrows -> [T]
}

extension KeyValueMap {
    var count: Int { values.count }
    
    subscript(key: KeyValuePair.Key) -> KeyValuePair? {
        get { values[key] }
        set { values[key] = newValue }
    }
    
    func has(_ value: KeyValuePair) -> Bool { values[value.key] != nil }
    func has(key: KeyValuePair.Key) -> Bool { values[key] != nil }
    func has(value: KeyValuePair.Value) -> Bool {
        for keyValuePair in values {
            if keyValuePair.value.value == value { return true }
        }
        return false
    }
    
    func get(forKey key: KeyValuePair.Key) -> KeyValuePair? { values[key] }
    func getValue(forKey key: KeyValuePair.Key) -> KeyValuePair.Value? { values[key]?.value }
    
    mutating func set(_ value: KeyValuePair, for key: KeyValuePair.Key) { values[key] = value }
    mutating func setValue(_ value: KeyValuePair.Value, for key: KeyValuePair.Key) { values[key]?.value = value }
    
    mutating func remove(key: KeyValuePair.Key) -> KeyValuePair.Value? { values.removeValue(forKey: key)?.value }
    
    @discardableResult
    func map<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair)) throws -> T) rethrows -> [T] {
        try values.map(transform)
    }
    
    @discardableResult
    func mapValues<T>(_ transform: ((key: KeyValuePair.Key, value: KeyValuePair.Value)) throws -> T) rethrows -> [T] {
        try values.map { try transform((key: $0.key, value: $0.value.value)) }
    }
}
