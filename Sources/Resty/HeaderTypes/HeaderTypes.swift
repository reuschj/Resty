//
//  HeaderTypes.swift
//  Resty
//
//  Created by Justin Reusch on 3/14/20.
//

import Foundation

public extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String { Data(self.utf8).base64EncodedString() }
}

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

public protocol AuthenticationValue {
    var type: AuthenticationScheme { get set }
}

public struct Authorization: AuthenticationValue, CustomStringConvertible {
    public var type: AuthenticationScheme = .basic
    private var _credentials: String? = nil
    private var _username: String = ""
    private var _password: String = ""
    public var credentials: String? {
        get { _credentials }
        set {
            let result: String? = newValue?.fromBase64()
            self._credentials = newValue
            if let result = result {
                let split = result.split(separator: ":")
                if let username = split.first {
                    self._username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if let password = split.last {
                    self._password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
    }
    public var username: String {
        get { _username }
        set {
            self._username = newValue
            self._credentials = "\(newValue):\(password)".toBase64()
        }
    }
    public var password: String {
        get { _password }
        set {
            self._password = newValue
            self._credentials = "\(username):\(newValue)".toBase64()
        }
    }
    
    public init(type: AuthenticationScheme = .basic, credentials: String? = nil) {
        self.type = type
        self.credentials = credentials
    }
    
    public init(type: AuthenticationScheme = .basic, username: String, password: String) {
        self.type = type
        self.credentials = nil
        self.username = username
        self.password = password
    }
    
    public var description: String {
        if let credentials = self.credentials {
            return "\(type) \(credentials)"
        } else {
            return "\(type)"
        }
    }
}

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
