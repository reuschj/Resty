//
//  Response.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

public typealias ResponseChecker = (HTTPURLResponse?) -> Bool

struct Response {
    private var _result: Result<Data, RESTCallError>! = nil
    var result: Result<Data, RESTCallError> {
        get { self._result }
        set { self._result = newValue }
    }
    var data: Data?
    var error: RESTCallError?
    var baseError: Error?
    var httpURLResponse: HTTPURLResponse?
    var headers: HTTPHeaders = HTTPHeaders()
    
    private var successCondition: ResponseChecker = Response.defaultSuccessCondition {
        didSet { setResult() }
    }
    
    var statusCode: Int { httpURLResponse?.statusCode ?? 500 }
    var url: URL? { httpURLResponse?.url }
    var mimeType: String? { httpURLResponse?.mimeType }
    var allHeaderFields: [AnyHashable : Any] { httpURLResponse?.allHeaderFields ?? [:] }
    
    init(data: Data?, response: HTTPURLResponse? = nil, error: Error? = nil, successCondition: @escaping ResponseChecker = Response.defaultSuccessCondition) {
        self.data = data
        self.httpURLResponse = response
        self.baseError = error
        self.successCondition = successCondition
        self.setResult(data: data, response: response)
        _ = response?.allHeaderFields.map { header in
            guard let key = header.key as? String, let value = header.value as? String else { return }
            let httpHeader = HTTPHeader(key: key, value: value)
            self.headers.set(httpHeader, forKey: key)
        }
    }
    
    init(data: Data?, response: URLResponse?, error: Error? = nil, successCondition: @escaping ResponseChecker = Response.defaultSuccessCondition) {
        let httpURLResponse = response as? HTTPURLResponse
        self.init(data: data, response: httpURLResponse, error: error, successCondition: successCondition)
    }
    
    private mutating func setResult(data: Data? = nil, response: HTTPURLResponse? = nil) {
        var error: RESTCallError
        guard let data = data else {
            error = .noData(description: String(describing: baseError))
            self.error = error
            self.result = .failure(error)
            return
        }
        let success = successCondition(response)
        if success {
            self.error = nil
            self.result = .success(data)
        } else {
            var error: RESTCallError
            switch statusCode {
            case 400:
                error = .badRequest(data: data)
            case 401:
                error = .unauthorized(data: data)
            case 403:
                error = .forbidden(data: data)
            case 404:
                error = .notFound(data: data)
            case 500:
                error = .internalServerError(data: data)
            default:
                error = .otherFailureCode(statusCode: statusCode, data: data)
            }
            self.error = error
            self.result = .failure(error)
        }
    }
    
    static let defaultSuccessCondition: ResponseChecker = { httpURLResponse in
        let statusCode = httpURLResponse?.statusCode ?? 500
        return statusCode >= 100 && statusCode < 300
    }
}

enum ResponseHeader: CustomStringConvertible {
    case acceptPatch
    case acceptRanges
    case acceptLanguage
    case accessControlAllowCredentials
    case accessControlAllowMethods
    case accessControlAllowHeaders
    case accessControlExposeHeaders
    case accessControlMaxAge
    case age
    case allow
    case altSvc
    case cacheControl
    case connection
    case contentMD5
    case contentDisposition
    case contentEncoding
    case contentType
    case contentLength
    case contentRange
    case contentLocation
    case date
    case deltaBase
    case eTag
    case expires
    case im
    case lastModified
    case link
    case location
    case p3p
    case pragma
    case proxyAuthenticate
    case publicKeyPins
    case retryAfter
    case server
    case setCookie
    case strictTransportSecurity
    case trailer
    case tk
    case transferEncoding
    case upgrade
    case via
    case vary
    case warning
    case wwwAuthenticate
    case xFrameOptions
    case other(key: String, value: String)
    
    var key: String {
        switch self {
        case .acceptPatch: return "Accept-Patch"
        case .acceptRanges: return "Accept-Ranges"
        case .acceptLanguage: return "Accept-Language"
        case .accessControlAllowCredentials: return "Access-Control-Allow-Credentials"
        case .accessControlAllowMethods: return "Access-Control-Allow-Methods"
        case .accessControlAllowHeaders: return "Access-Control-Allow-Headers"
        case .accessControlExposeHeaders: return "Access-Control-Expose-Headers"
        case .accessControlMaxAge: return "Access-Control-Max-Age"
        case .age: return "Age"
        case .allow: return "Allow"
        case .altSvc: return "Alt-Svc"
        case .cacheControl: return "Cache-Control"
        case .connection: return "Connection"
        case .contentMD5: return "Content-MD5"
        case .contentDisposition: return "Content-Disposition"
        case .contentEncoding: return "Content-Encoding"
        case .contentType: return "Content-Type"
        case .contentLength: return "Content-Length"
        case .contentRange: return "Content-Range"
        case .contentLocation: return "Content-Location"
        case .date: return "Date"
        case .deltaBase: return "Delta-Base"
        case .eTag: return "ETag"
        case .expires: return "Expires"
        case .im: return "IM"
        case .lastModified: return "Last-Modified"
        case .link: return "Link"
        case .location: return "Location"
        case .p3p: return "PEP"
        case .pragma: return "Pragma"
        case .proxyAuthenticate: return "Proxy-Authenticate"
        case .publicKeyPins: return "Public-Key-Pins"
        case .retryAfter: return "Retry-After"
        case .server: return "Server"
        case .setCookie: return "Set-Cookie"
        case .strictTransportSecurity: return "Strict-Transport-Security"
        case .trailer: return "Trailer"
        case .tk: return "Tk"
        case .transferEncoding: return "Transfer-Encoding"
        case .upgrade: return "Upgrade"
        case .via: return "Via"
        case .vary: return "Vary"
        case .warning: return "Warning"
        case .wwwAuthenticate: return "WWW-Authenticate"
        case .xFrameOptions: return "X-Frame-Options"
        case .other(let key, _): return key
        }
    }
    
    // TODO: More copied from Request
    
    var description: String { self.key }
}
