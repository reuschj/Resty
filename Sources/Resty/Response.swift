//
//  Response.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

typealias ResponseChecker = (HTTPURLResponse?) -> Bool

struct Response {
    var data: Data?
    var httpURLResponse: HTTPURLResponse?
    var error: Error?
    var successCondition: ResponseChecker = Response.defaultSuccessCondition {
        didSet { setResult() }
    }
    var headers: HTTPHeaders = HTTPHeaders()
    var result: Result<Data, RestyError>! = nil
    
    var statusCode: Int { httpURLResponse?.statusCode ?? 500 }
    var url: URL? { httpURLResponse?.url }
    var mimeType: String? { httpURLResponse?.mimeType }
    var allHeaderFields: [AnyHashable : Any] { httpURLResponse?.allHeaderFields ?? [:] }
    
    init(data: Data?, response: HTTPURLResponse? = nil, error: Error? = nil, successCondition: @escaping ResponseChecker = Response.defaultSuccessCondition) {
        self.data = data
        self.httpURLResponse = response
        self.error = error
        self.successCondition = successCondition
        self.setResult()
        response?.allHeaderFields.map { header in
            guard let key = header.key as? String, let value = header.value as? String else { return }
            self.headers.set(value, for: key)
        }
    }
    
    init(data: Data?, response: URLResponse?, error: Error? = nil, successCondition: @escaping ResponseChecker = Response.defaultSuccessCondition) {
        let httpURLResponse = response as? HTTPURLResponse
        self.init(data: data, response: httpURLResponse, error: error, successCondition: successCondition)
    }
    
    private mutating func setResult() {
        guard let data = self.data else {
            self.result = .failure(.noData(String(describing: error)))
            return
        }
        let success = successCondition(self.httpURLResponse)
        if success {
            self.result = .success(data)
        } else {
            switch statusCode {
            case 400:
                self.result = .failure(.badRequest(data))
            case 401:
                self.result = .failure(.unauthorized(data))
            case 403:
                self.result = .failure(.forbidden(data))
            case 404:
                self.result = .failure(.notFound(data))
            case 500:
                self.result = .failure(.internalServerError(data))
            default:
                self.result = .failure(.otherFailureCode(statusCode, data))
            }
        }
    }
    
    enum CommonResponseHeaders: String, CustomStringConvertible {
        case acceptPatch = "Accept-Patch"
        case acceptRanges = "Accept-Ranges"
        case acceptLanguage = "Accept-Language"
        case accessControlAllowCredentials = "Access-Control-Allow-Credentials"
        case accessControlAllowMethods = "Access-Control-Allow-Methods"
        case accessControlAllowHeaders = "Access-Control-Allow-Headers"
        case accessControlExposeHeaders = "Access-Control-Expose-Headers"
        case accessControlMaxAge = "Access-Control-Max-Age"
        case age = "Age"
        case allow = "Allow"
        case altSvc = "Alt-Svc"
        case cacheControl = "Cache-Control"
        case connection = "Connection"
        case contentMD5 = "Content-MD5"
        case contentDisposition = "Content-Disposition"
        case contentEncoding = "Content-Encoding"
        case contentType = "Content-Type"
        case contentLength = "Content-Length"
        case contentRange = "Content-Range"
        case contentLocation = "Content-Location"
        case date = "Date"
        case deltaBase = "Delta-Base"
        case eTag = "ETag"
        case expires = "Expires"
        case im = "IM"
        case lastModified = "Last-Modified"
        case link = "Link"
        case location = "Location"
        case p3p = "PEP"
        case pragma = "Pragma"
        case proxyAuthenticate = "Proxy-Authenticate"
        case publicKeyPins = "Public-Key-Pins"
        case retryAfter = "Retry-After"
        case server = "Server"
        case setCookie = "Set-Cookie"
        case strictTransportSecurity = "Strict-Transport-Security"
        case trailer = "Trailer"
        case tk = "Tk"
        case transferEncoding = "Transfer-Encoding"
        case upgrade = "Upgrade"
        case via = "Via"
        case vary = "Vary"
        case warning = "Warning"
        case wwwAuthenticate = "WWW-Authenticate"
        case xFrameOptions = "X-Frame-Options"
        
        var description: String { self.rawValue }
    }
    
    static let defaultSuccessCondition: ResponseChecker = { httpURLResponse in
        let statusCode = httpURLResponse?.statusCode ?? 500
        return statusCode >= 100 && statusCode < 300
    }
}
