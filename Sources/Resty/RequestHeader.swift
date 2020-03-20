//
//  RequestHeader.swift
//  Resty
//
//  Created by Justin Reusch on 3/14/20.
//

import Foundation

/// An enum of the most common request header settings
// TODO: Dig into more of these
public enum RequestHeader: CustomStringConvertible {
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
