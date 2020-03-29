//
//  CacheControl.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public enum CacheControl: CustomStringConvertible {
    case maxAge(Int)
    case maxStale(Int)
    case minFresh(Int)
    case noCache
    case noStore
    case noTransform
    case onlyIfCached
    
    public var description: String {
        switch self {
        case .maxAge(let seconds): return "max-age=<\(seconds)>"
        case .maxStale(let seconds): return "max-stale[=<\(seconds)>]"
        case .minFresh(let seconds): return "min-fresh=<\(seconds)>"
        case .noCache: return "no-cache"
        case .noStore: return "no-store"
        case .noTransform: return "no-transform"
        case .onlyIfCached: return "only-if-cached"
        }
    }
}
