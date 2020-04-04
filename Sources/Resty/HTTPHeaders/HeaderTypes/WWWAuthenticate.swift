//
//  WWWAuthenticate.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public struct WWWAuthenticate: AuthenticationValue, CustomStringConvertible {
    public var type: AuthenticationScheme = .basic
    public var realm: String? = nil
    public var charset: String? = nil
    
    public init(type: AuthenticationScheme = .basic, realm: String? = nil, charset: String? = nil) {
        self.type = type
        self.realm = realm
        self.charset = charset
    }
    
    public init(type: AuthenticationScheme = .basic, realm: String? = nil, charset: String.Encoding = .utf8) {
        let split = charset.description.components(separatedBy: "(")
        let split2 = split.last?.components(separatedBy: ")")
        let charsetDescription = split2?.first?.count ?? 0 > 0 ? split2?.first : nil
        self.init(type: type, realm: realm, charset: charsetDescription)
    }
    
    public var description: String {
        var output = "\(type)"
        if let realm = self.realm {
            output.append(" realm=\"\(realm)\"")
        }
        if let charset = self.charset {
            output.append(" charset=\"\(charset)\"")
        }
        return output
    }
}
