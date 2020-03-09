//
//  HTTPHeaders.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

public extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String { Data(self.utf8).base64EncodedString() }
}

enum CacheControl: CustomStringConvertible {
    case maxAge(Int)
    case maxStale(Int)
    case minFresh(Int)
    case noCache
    case noStore
    case noTransform
    case onlyIfCached
    
    var description: String {
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

enum Connection: CustomStringConvertible {
    case keepAlive([String]? = nil)
    case close
    
    var description: String {
        switch self {
        case .keepAlive(let headerList): return headerList?.joined(separator: ", ") ?? "keep-alive"
        case .close: return "close"
        }
    }
}

enum AuthenticationScheme: String, CustomStringConvertible {
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
    
    var description: String { self.rawValue }
}

protocol AuthenticationValue {
    var type: AuthenticationScheme { get set }
}

struct Authorization: AuthenticationValue, CustomStringConvertible {
    var type: AuthenticationScheme = .basic
    private var _credentials: String? = nil
    private var _username: String = ""
    private var _password: String = ""
    var credentials: String? {
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
    var username: String {
        get { _username }
        set {
            self._username = newValue
            self._credentials = "\(newValue):\(password)".toBase64()
        }
    }
    var password: String {
        get { _password }
        set {
            self._password = newValue
            self._credentials = "\(username):\(newValue)".toBase64()
        }
    }
    
    init(type: AuthenticationScheme = .basic, credentials: String? = nil) {
        self.type = type
        self.credentials = credentials
    }
    
    init(type: AuthenticationScheme = .basic, username: String, password: String) {
        self.type = type
        self.credentials = nil
        self.username = username
        self.password = password
    }
    
    var description: String {
        if let credentials = self.credentials {
            return "\(type) \(credentials)"
        } else {
            return "\(type)"
        }
    }
}

struct ProxyAuthenticate: AuthenticationValue, CustomStringConvertible {
    var type: AuthenticationScheme = .basic
    var realm: String? = nil
    
    init(type: AuthenticationScheme = .basic, realm: String? = nil) {
        self.type = type
        self.realm = realm
    }
    
    var description: String {
        if let realm = self.realm {
            return "\(type) realm=\"\(realm)\""
        } else {
            return "\(type)"
        }
    }
}

struct WWWAuthenticate: AuthenticationValue, CustomStringConvertible {
    var type: AuthenticationScheme = .basic
    var realm: String? = nil
    var charset: String? = nil
    
    init(type: AuthenticationScheme = .basic, realm: String? = nil, charset: String? = nil) {
        self.type = type
        self.realm = realm
        self.charset = charset
    }
    
    init(type: AuthenticationScheme = .basic, realm: String? = nil, charset: String.Encoding = .utf8) {
        let split = charset.description.components(separatedBy: "(")
        let split2 = split.last?.components(separatedBy: ")")
        let charsetDescription = split2?.first?.count ?? 0 > 0 ? split2?.first : nil
        self.init(type: type, realm: realm, charset: charsetDescription)
    }
    
    var description: String {
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

enum RequestHeader: CustomStringConvertible {
    case accept(ContentType)
    case acceptCharset(String)
    case acceptEncoding(String)
    case acceptLanguage(String)
    case accessControlRequestHeaders(String)
    case accessControlRequestMethod(String)
    case authorization(Authorization)
    case cacheControl(CacheControl)
    case connection(Connection)
    case contentMD5(String)
    case contentLength(String)
    case contentTransferEncoding(String)
    case contentType(ContentType)
    case cookie(String)
    case cookie2(String)
    case date(String)
    case dnt(String)
    case expect(String)
    case from(String)
    case host(String)
    case ifMatch(String)
    case ifModifiedSince(String)
    case ifNoneMatch(String)
    case ifRange(String)
    case ifUnmodifiedSince(String)
    case keepAlive([String:CustomStringConvertible])
    case maxForwards(String)
    case origin(String)
    case pragma(String)
    case proxyAuthorization(String)
    case referer(String)
    case te(String)
    case transferEncoding(String)
    case upgrade(String)
    case userAgent(String)
    case via(String)
    case warning(String)
    case xRequestedWith(String)
    case xDoNotTrack(String)
    case xAPIKey(String)
    case other(key: String, value: String)
    
    var key: String {
        switch self {
        case .accept: return "Accept"
        case .acceptCharset: return "Accept-Charset"
        case .acceptEncoding: return "Accept-Encoding"
        case .acceptLanguage: return "Accept-Language"
        case .accessControlRequestHeaders: return "Access-Control-Request-Headers"
        case .accessControlRequestMethod: return "Access-Control-Request-Method"
        case .authorization: return "Authorization"
        case .cacheControl: return "Cache-Control"
        case .connection: return "Connection"
        case .contentMD5: return "Content-MD5"
        case .contentLength: return "Content-Length"
        case .contentTransferEncoding: return "Content-Transfer-Encoding"
        case .contentType: return "Content-Type"
        case .cookie: return "Cookie"
        case .cookie2: return "Cookie2"
        case .date: return "Date"
        case .dnt: return "DNT"
        case .expect: return "Expect"
        case .from: return "From"
        case .host: return "Host"
        case .ifMatch: return "If-Match"
        case .ifModifiedSince: return "If-Modified-Since"
        case .ifNoneMatch: return "If-None-Match"
        case .ifRange: return "If-Range"
        case .ifUnmodifiedSince: return "If-Unmodified-Since"
        case .keepAlive: return "Keep-Alive"
        case .maxForwards: return "Max-Forwards"
        case .origin: return "Origin"
        case .pragma: return "Pragma"
        case .proxyAuthorization: return "Proxy-Authorization"
        case .referer: return "Referer"
        case .te: return "TE"
        case .transferEncoding: return "Transfer-Encoding"
        case .upgrade: return "Upgrade"
        case .userAgent: return "User-Agent"
        case .via: return "Via"
        case .warning: return "Warning"
        case .xRequestedWith: return "X-Requested-With"
        case .xDoNotTrack: return "X-Do-Not-Track"
        case .xAPIKey: return "x-api-key"
        case .other(let key, _): return key
        }
    }
    
    var value: String {
        switch self {
        case .accept(let value): return value.description
        case .acceptCharset(let value): return value
        case .acceptEncoding(let value): return value
        case .acceptLanguage(let value): return value
        case .accessControlRequestHeaders(let value): return value
        case .accessControlRequestMethod(let value): return value
        case .authorization(let value): return value.description
        case .cacheControl(let cacheControlType): return cacheControlType.description
        case .connection(let value): return value.description
        case .contentMD5(let value): return value
        case .contentLength(let value): return value
        case .contentTransferEncoding(let value): return value
        case .contentType(let contentType): return contentType.description
        case .cookie(let value): return value
        case .cookie2(let value): return value
        case .date(let value): return value
        case .dnt(let value): return value
        case .expect(let value): return value
        case .from(let value): return value
        case .host(let value): return value
        case .ifMatch(let value): return value
        case .ifModifiedSince(let value): return value
        case .ifNoneMatch(let value): return value
        case .ifRange(let value): return value
        case .ifUnmodifiedSince(let value): return value
        case .keepAlive(let dictionary):
            let params = dictionary.map { "\($0.key)=\(String(describing: $0.value))" }
            return params.joined(separator: ", ")
        case .maxForwards(let value): return value
        case .origin(let value): return value
        case .pragma(let value): return value
        case .proxyAuthorization(let value): return value
        case .referer(let value): return value
        case .te(let value): return value
        case .transferEncoding(let value): return value
        case .upgrade(let value): return value
        case .userAgent(let value): return value
        case .via(let value): return value
        case .warning(let value): return value
        case .xRequestedWith(let value): return value
        case .xDoNotTrack(let value): return value
        case .xAPIKey(let value): return value
        case .other(let key, _): return key
        }
    }
    
    var header: HTTPHeader { HTTPHeader(key: key, value: value) }
    
    var description: String { "\(self.key): \(self.value)" }
}

struct HTTPHeader: Hashable, Equatable, KeyValueStore {
    var key: String
    var value: String
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    init(with header: RequestHeader) {
        self.init(key: header.key, value: header.value)
    }
}

struct HTTPHeaders: KeyValueMap {
    var values: [String : HTTPHeader] = [:]
    mutating func setValue(_ value: KeyValuePair.Value, for key: KeyValuePair.Key) {
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
        _ = headers.map { self.set($0.header, for: $0.key) }
    }
    init(with headers: RequestHeader...) {
        self.init(with: headers)
    }
    init(with headers: Set<HTTPHeader>) {
         _ = headers.map { self.set($0, for: $0.key) }
    }
    init(with headers: [HTTPHeader]) {
        _ = headers.map { self.set($0, for: $0.key) }
    }
    init(with headers: HTTPHeader...) {
         self.init(with: headers)
    }
    var headerList: [HTTPHeader] { Array(self.values.values) }
    var headerSet: Set<HTTPHeader> { Set(self.values.values) }
}
