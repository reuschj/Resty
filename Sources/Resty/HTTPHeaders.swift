//
//  HTTPHeaders.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

struct HTTPHeaders: KeyValueMap {
    var values: [String : HTTPHeader] = [:]
    mutating func setValue(_ value: String, for key: String) {
        if var header = values[key] {
            header.value = value
        } else {
            values[key] = HTTPHeader(key: key, value: value)
        }
    }
    init(with values: [String : String] = [:]) {
        _ = values.map { self.setValue($0.value, for: $0.key) }
    }
    init(with headers: [RequestHeader]) {
        _ = headers.map { self.set($0.header, forKey: $0.key) }
    }
    init(with headers: RequestHeader...) {
        self.init(with: headers)
    }
    init(with headers: Set<HTTPHeader>) {
         _ = headers.map { self.set($0, forKey: $0.key) }
    }
    init(with headers: [HTTPHeader]) {
        _ = headers.map { self.set($0, forKey: $0.key) }
    }
    init(with headers: HTTPHeader...) {
         self.init(with: headers)
    }
    var headerList: [HTTPHeader] { Array(self.values.values) }
    var headerSet: Set<HTTPHeader> { Set(self.values.values) }
}
