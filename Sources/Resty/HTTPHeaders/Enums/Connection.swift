//
//  Connection.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public enum Connection: CustomStringConvertible {
    case keepAlive([String]? = nil)
    case close
    
    public var description: String {
        switch self {
        case .keepAlive(let headerList): return headerList?.joined(separator: ", ") ?? "keep-alive"
        case .close: return "close"
        }
    }
}
