//
//  ProxyAuthenticate.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public struct ProxyAuthenticate: AuthenticationValue, CustomStringConvertible {
    public var type: AuthenticationScheme = .basic
    var realm: String? = nil
    
    public init(type: AuthenticationScheme = .basic, realm: String? = nil) {
        self.type = type
        self.realm = realm
    }
    
    public var description: String {
        if let realm = self.realm {
            return "\(type) realm=\"\(realm)\""
        } else {
            return "\(type)"
        }
    }
}
