//
//  AuthenticationScheme.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public enum AuthenticationScheme: String, CustomStringConvertible {
    case basic = "Basic"
    case bearer = "Bearer"
    case digest = "Digest"
    case hoba = "HOBA"
    case mutual = "Mutual"
    case negotiate = "Negotiate"
    case oAuth = "OAuth"
    case scramSHA1 = "SCRAM-SHA-1"
    case scramSHA256 = "SCRAM-SHA-256"
    case vapid = "vapid"
    
    public var description: String { self.rawValue }
}
